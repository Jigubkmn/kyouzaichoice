class MaterialsController < ApplicationController
  before_action :require_login, except: %i[index show]
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
      Rails.logger.debug "@material111111: #{@material.inspect}"
      @material_evaluation = @material.material_evaluations.build.comments.build
      Rails.logger.debug "@material_evaluations_new: #{@material_evaluations.inspect}"
    end
  end

  def index
    @materials = Material.includes(material_evaluations: :comments).all
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

  def show
    @evaluations = @material.material_evaluations.includes(:comments)
    calculate_material_details(@evaluations) # 教材評価平均、教材評価数、教材特徴
    # @evaluation = Material.new(material_params)
    # ログインユーザー教材情報(教材評価、コメント)
    login_user_evaluation_information(@evaluations)
    # ログインユーザー以外の教材評価とコメントを取得
    @other_evaluations = @evaluations.reject { |evaluation| evaluation.user == current_user }

    Rails.logger.debug "@other_evaluations: #{@other_evaluations.inspect}"
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
      Rails.logger.debug "@material111111: #{@material.inspect}"
      @material_evaluation = @material.material_evaluations.build(material_params[:material_evaluations_attributes].values.first)
      Rails.logger.debug "@material_evaluation111111: #{@material_evaluation.inspect}"
      # 教材は既に登録済み。教材情報のみ登録
      if @material_evaluation.save
        redirect_to already_registered_materials_path, success: t('materials.create.success')
      else
        flash.now[:danger] = t('materials.create.danger')
        render :new, status: :unprocessable_entity
      end
    else
      @material = Material.new(material_params)
      # ユーザー情報を設定
      @material.material_evaluations.each do |evaluation|
        evaluation.user = current_user
        evaluation.comments.each do |comment|
          comment.user = current_user
        end
      end
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
      evaluation.comments.build if evaluation.comments.where(user: current_user).empty?
    end
  end

  def update
    material_params[:material_evaluations_attributes]&.each do |_, evaluation_attrs|
      if evaluation_attrs[:comments_attributes]
        evaluation_attrs[:comments_attributes].each do |_, comment_attrs|
          comment_attrs[:user_id] = current_user.id if comment_attrs[:user_id].blank?
        end
      end
    end
    if @material.update(material_params)
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

  # indexとshow用
  def calculate_material_details(evaluations)
    @average_evaluation = evaluations.average(:evaluation).to_f.round(1) # 教材評価平均
    @count_of_unique_evaluators = evaluations.select(:user_id).distinct.count # 教材評価者数
    @unique_features = evaluations.flat_map(&:feature).reject { |f| f == 'true' }.uniq # 教材特徴
  end

  # show用
  def login_user_evaluation_information(evaluations)
    # ログインユーザーの評価を取得
    user_evaluation = @evaluations.find { |evaluation| evaluation.user == current_user }
    @user_evaluation = user_evaluation&.evaluation
    # ログインユーザーの教材コメントを取得
    @comments = @evaluations.flat_map(&:comments)
    @user_comment = @comments.find { |comment| comment.user == current_user }
  end

  # new用、already_registered用
  def login_material_evaluations
    material_evaluations = current_user.material_evaluations.includes(:material, :comments)
    @materials = material_evaluations.map(&:material).uniq
    @user_comments = material_evaluations.flat_map(&:comments)
  end

  def material_params
    params.require(:material).permit(
      :title, :image_link, :published_date, :info_link, :systemid,
      material_evaluations_attributes: [
        :id, :evaluation, :_destroy,
        { feature: [] },
        { comments_attributes: %i[id body _destroy] }
      ]
    )
  end

  def set_material
    @material = Material.find(params[:id])
  end
end
