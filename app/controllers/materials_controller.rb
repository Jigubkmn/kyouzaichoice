class MaterialsController < ApplicationController
  before_action :require_login
  before_action :set_material, only: %i[edit update destroy]

  def new
    @material = Material.new(material_params)
    @material.material_evaluations.build.comments.build
  end

  def index
    @materials = Material.all
    @user_comments = current_user.comments.where(commentable_type: 'MaterialEvaluation')
  end

  def like
    @materials = Material.all
  end

  # プロフィール(教材) 追加済み教材
  def already_registered
    # ログインユーザーに関連するMaterialEvaluation を取得
    material_evaluations = current_user.material_evaluations.includes(:material, :comments)
    # ログインユーザーに関連する Material を取得
    @materials = material_evaluations.map(&:material).uniq
    # ログインユーザーに関連する Comment を取得
    @user_comments = material_evaluations.flat_map(&:comments)
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
      render :new
    end
  end

  def edit
    @material = Material.find(params[:id])
    # 既存のmaterial_evaluationsとそのコメントを読み込む
    @material.material_evaluations.each do |evaluation|
      evaluation.comments.build if evaluation.comments.empty?
    end
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
    @material.destroy
    redirect_to already_registered_materials_path, success: t('materials.destroy.success')
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
