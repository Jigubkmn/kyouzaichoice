class MaterialsController < ApplicationController
  before_action :require_login
  before_action :set_material, only: %i[edit update destroy]

  def new
    @material = Material.new(material_params)
    @material.material_evaluations.build.comments.build
  end

  def index
    @materials = Material.all
    # 評価の平均値を計算
    @materials_with_details = @materials.map do |material|
      evaluations = material.material_evaluations
      # 教材評価の平均値を計算
      total_evaluation = evaluations.sum(:evaluation) # 合計値
      count_of_unique_evaluators = evaluations.select(:user_id).distinct.count # 評価を行ったユーザーの数
      average_evaluation = count_of_unique_evaluators > 0 ? (total_evaluation / count_of_unique_evaluators.to_f).round(1) : 0 #評価平均値

      # 教材特徴
      unique_features = evaluations.flat_map(&:feature).reject { |f| f == 'true' }.uniq

      # 各教材に関連する評価のコメント数を計算
      comments_count = evaluations.joins(:comments).count

      material.as_json.merge(
        average_evaluation: average_evaluation,
        count_of_unique_evaluators: count_of_unique_evaluators,
        unique_features: unique_features,
        comments_count: comments_count
      )
    end
  end

  def show
    @material = Material.find(params[:id])
  end

  # プロフィール(教材) 登録済み
  def already_registered
    # ログインユーザーに関連するMaterialEvaluation を取得
    material_evaluations = current_user.material_evaluations.includes(:material, :comments)
    @materials = material_evaluations.map(&:material).uniq
    @user_comments = material_evaluations.flat_map(&:comments)
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
      res = Faraday.get(url, q: text, langRestrict: 'ja', maxResults: 20)
      @google_materials = JSON.parse(res.body)
    end
  end

  def create
    # 既に同じMaterialが存在するかチェック
    existing_material = Material.find_by(title: material_params[:title], systemid: material_params[:systemid])
  
    if existing_material
      # 既存のMaterialを使用し、関連するMaterialEvaluationとCommentを新規作成
      @material = existing_material
      @material_evaluation = @material.material_evaluations.new(material_params[:material_evaluations_attributes].values.first)
      
      # バリデーションで、同じMaterialに複数のMaterialEvaluationが保存されないようにする
      if @material.material_evaluations.exists?(user: current_user)
        flash.now[:notice] = t('materials.create.notice')
        render :new
        return
      end

      @material_evaluation.user = current_user
      @material_evaluation.comments.each do |comment|
        comment.user = current_user
      end

      if @material_evaluation.save
        redirect_to already_registered_materials_path, success: t('materials.create.success')
      else
        Rails.logger.debug @material_evaluation.errors.full_messages
        flash.now[:danger] = t('materials.create.danger')
        render :new
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
        Rails.logger.debug @material.errors.full_messages
        flash.now[:danger] = t('materials.create.danger')
        render :new
      end
    end
  end

  def edit
    @material = Material.find(params[:id])
    # ログインユーザーに関連するMaterialEvaluationとコメントのみを読み込む
    @material_evaluations = @material.material_evaluations.where(user: current_user)
    @material_evaluations.each do |evaluation|
      # ログインユーザーに関連するコメントのみを読み込む
      evaluation.comments.build if evaluation.comments.where(user: current_user).empty?
    end
    # 既存のmaterial_evaluationsとそのコメントを読み込む
    #@material.material_evaluations.each do |evaluation|
     # evaluation.comments.build if evaluation.comments.empty?
    #end
  end

  def update
    if @material.update(material_params)
      redirect_to already_registered_materials_path, success: t('materials.update.success')
    else
      flash.now[:danger] = t('materials.update.danger')
      render :edit
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
    # @material.destroy
    # redirect_to already_registered_materials_path, success: t('materials.destroy.success')
  end

  private

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
    @material.material_evaluations.includes(:comments) # 関連するMaterialEvaluationとそのコメントを読み込む
  end
end