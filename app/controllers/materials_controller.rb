class MaterialsController < ApplicationController
  before_action :require_login, except: %i[index]
  before_action :set_material, only: %i[edit show update destroy]

  def new
    # 既に登録済みの教材かチェック
    existing_material = Material.find_by(title: material_params[:title], systemid: material_params[:systemid])
    # 既に登録済みの教材で評価済みかチェック
    if existing_material && existing_material.material_evaluations.exists?(user: current_user)
      login_material_evaluations # ログインユーザーに関連するMaterialEvaluationを取得
      flash.now[:notice] = t('materials.create.notice')
      render :already_registered, status: :unprocessable_entity
      return
    else
      @material = Material.new(material_params)
      @material_evaluation = @material.material_evaluations.build.comments.build
    end
  end

  def index
    @q = Material.ransack(params[:q])
    # @material_evaluations = @material.material_evaluations
    Rails.logger.debug "@q-1: #{@q.inspect}"
    # 教材と教材評価データを一度に取得
    if params[:q].present? && params[:q][:material_evaluations_feature_eq].present?
      # Rails.logger.debug "params[:q][:material_evaluations_feature_eq]: #{params[:q][:material_evaluations_feature_eq].inspect}"
      # チェックボックスのチェック内容を表示
      selected_features = params[:q][:material_evaluations_feature_eq].join(',').gsub('"', '')
      # params[:q][:material_evaluations_feature_eq] = selected_features
      # Rails.logger.debug "selected_features: #{selected_features}"
     
      # 教材評価で選択された特徴が含まれているものを検索
      @materials = @q.result(distinct: true)
                     .eager_load(material_evaluations: :comments)
                     .where('material_evaluations.feature LIKE ?', "%#{selected_features}%")
                     .page(params[:page])
                     .per(10)
    else
      @materials = @q.result(distinct: true)
                    .eager_load(material_evaluations: :comments)
                    .page(params[:page])
                    .per(10)
    end
    @materials_with_details = @materials.map do |material|
      @evaluations = material.material_evaluations
      calculate_material_details(@evaluations) # 教材評価平均、教材評価数、教材特徴
      comments_count = @evaluations.joins(:comments).count # 各教材に関連する評価のコメント数を計算
      merged_data = material.as_json.merge(
        average_evaluation: @average_evaluation,
        count_of_unique_evaluators: @count_of_unique_evaluators,
        unique_features: @unique_features,
        comments_count: comments_count
      )
      merged_data
    end
  end

  # プロフィール(教材) 登録済み
  def already_registered
    login_material_evaluations # ログインユーザーに関連するMaterialEvaluationを取得
  end

  # プロフィール(教材) いいね
  def like
    @materials = Material.all
  end

  def search
    if params[:search].nil?
      return
    elsif params[:search].blank?
      flash.now[:danger] = t('materials.search.danger')
      return
    else
      url = 'https://www.googleapis.com/books/v1/volumes'
      text = params[:search]
      api_key = "AIzaSyCF4M_hTzqMlL8-jWMea55zHSFIEH-5dOc"
      res = Faraday.get(url, q: text, langRestrict: 'ja', maxResults: 20, key: api_key)
      @google_materials = JSON.parse(res.body)
    end
  end

  def create
    # 既に同じMaterialが存在するかチェック
    existing_material = Material.find_by(title: material_params[:title], systemid: material_params[:systemid])
    
    if existing_material
      # 既存のMaterialを使用し、関連するMaterialEvaluationとCommentを新規作成
      @material = existing_material
      @material_evaluation = @material.material_evaluations.build(material_params[:material_evaluations_attributes].values.first)
      process_features(@material_evaluation)  # 配列をカンマ潜りの文字列に変換
      uers_information(@material) # ユーザー情報を設定
      # 教材は既に登録済み。教材情報のみ登録
      if @material_evaluation.save
        redirect_to already_registered_materials_path, success: t('materials.create.success')
      else
        flash.now[:danger] = t('materials.create.danger')
        render :new, status: :unprocessable_entity
      end
    else
      @material = Material.new(material_params)
      uers_information(@material) # ユーザー情報を設定
      process_features(@material.material_evaluations.first)  # 追加: featureカラムの処理
      if @material.save
        redirect_to already_registered_materials_path, success: t('materials.create.success')
      else
        flash.now[:danger] = t('materials.create.danger')
        render :new, status: :unprocessable_entity 
      end
    end
  end

  def edit
    # ログインユーザーに関連するMaterialEvaluationとコメントのみを読み込む
    @material_evaluations = @material.material_evaluations.where(user: current_user)
    @material_evaluations.each do |evaluation|
      # ログインユーザーに関連するコメントのみを読み込む
      evaluation.comments.build if evaluation.comments.where(user: current_user).empty?    #evaluation.feature: "初学者,資格合格最低限内容,問題数多め"
      # evaluation.feature = evaluation.feature.split(",") if evaluation.feature.is_a?(String) #evaluation.feature: "[\"初学者\", \"資格合格最低限内容\", \"問題数多め\"]"
    end
  end

  def update
    @material_evaluations = @material.material_evaluations.find_by(user: current_user)
    if @material_evaluations.update(material_evaluation_params)
      process_features(@material_evaluations) # 配列をカンマ潜りの文字列に変換
      @material_evaluations.save # 変換後のデータを保存
      redirect_to already_registered_materials_path, success: t('materials.update.success')
    else
      flash.now[:danger] = t('materials.update.danger')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @material = Material.find(params[:id])
    # ログインユーザーが作成したmaterial_evationを取得
    user_evaluations = @material.material_evaluations.where(user: current_user)

    if user_evaluations.exists?
      # ログインユーザーが作成したMaterialEvaluationとそのコメントを削除
      user_evaluations.each do |evaluation|
        evaluation.comments.destroy_all
        evaluation.destroy
      end
  
      # 他のユーザーによる評価がない場合、Material自体を削除
      if @material.material_evaluations.empty?
        @material.destroy
      end
      redirect_to already_registered_materials_path, success: t('materials.destroy.success')
    end
  end

  private

  # index用
  def calculate_material_details(evaluations)
    @average_evaluation = evaluations.average(:evaluation).to_f.round(1) # 教材評価平均
    @count_of_unique_evaluators = evaluations.select(:user_id).distinct.count # 教材評価者数
    features = evaluations.pluck(:feature).map { |f| f.split(',') }.flatten # 教材特徴
    @unique_features = features.uniq
  end
  
  # create用　featureをカンマ区切りで保存
  # def process_features(evaluation)
  #  features = params[:material][:material_evaluations_attributes].values.first[:feature]
  #  if features.present?
  #    evaluation.feature = features.compact_blank.join(',')
  #  end
  # end

  def process_features(material_evaluations)
    if material_evaluations.feature.present?
      # JSON配列形式の文字列をRubyの配列に変換し、その後カンマ区切りの文字列に変換
      features_array = JSON.parse(material_evaluations.feature)
      material_evaluations.feature = features_array.join(',')
    end
  end

  # new用、already_registered用
  def login_material_evaluations
    @material_evaluations = current_user.material_evaluations.includes(:material, :comments).page(params[:page]).per(8)
    @materials = @material_evaluations.map(&:material).uniq # 対象materialデータ表示
    @user_comments = @material_evaluations.flat_map(&:comments) # 対象commentデータ表示
  end

  def uers_information(material)
    material.material_evaluations.each do |evaluation|
      evaluation.user = current_user
      evaluation.comments.each do |comment|
        comment.user = current_user
      end
    end
  end

  def material_params
    params.require(:material).permit(
      :title, :image_link, :published_date, :info_link, :systemid,
      material_evaluations_attributes: [
        :id, :evaluation, :_destroy, { feature: [] },
        { comments_attributes: %i[id body _destroy] }
      ]
    )
  end

  # update
  def material_evaluation_params
    params.require(:material).permit(
      material_evaluations_attributes: [
        :id, :evaluation, :_destroy, { feature: [] },
        { comments_attributes: %i[id body _destroy] }
      ]
    )[:material_evaluations_attributes]["0"]
  end

  def set_material
    @material = Material.find(params[:id])
  end
end
