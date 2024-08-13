class MaterialsController < ApplicationController
  before_action :require_login
  before_action :set_material, only: [:edit, :update, :destroy]

  def new
    @material = Material.new(material_params)
    @title = @material.title
    @material.material_evaluations.build.comments.build
  end  

  def index
    @material = Material.all
  end

  def search 
    if params[:search].nil?
      return
    elsif params[:search].blank?
      flash.now[:danger] = t('materials.create.success')
      return
    else
      url = "https://www.googleapis.com/books/v1/volumes"
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
      redirect_to materials_path, success: t('materials.create.success')
    else
      flash.now[:danger] = t('materials.create.danger')
      render :new
    end
  end

  private

  def material_params
    params.require(:material).permit(:title, :image_link, :published_date, :info_link, :systemid,
    material_evaluations_attributes: [
      :id, :evaluation, :_destroy, feature: [],
      comments_attributes: [:id, :body, :_destroy]
      ]
    )
  end
  
  def set_material
    @material = Material.find(params[:id])
  end

  def set_material_evaluation
    @materialEvaluation = MaterialEvaluation.find(params[:id])
  end
end
