class MaterialEvaluationsController < ApplicationController
  before_action :require_login, except: %i[show]
  before_action :set_material, only: %i[show create]

  def show
    @evaluations = @material.material_evaluations.includes(:comments)
    @material_evaluation = @material.material_evaluations.build
    @material_evaluation.comments.build
    calculate_material_details(@evaluations) # 教材評価平均、教材評価数、教材特徴
    # ログインユーザー教材情報(教材評価、コメント)
    login_user_evaluation_information(@evaluations)
    # ログインユーザー以外の教材評価とコメントを取得
    @other_evaluations = @evaluations.reject { |evaluation| evaluation.user == current_user }
  end

  def create
    @material_evaluation = @material.material_evaluations.build(material_evaluation_params)
    uers_information(@material_evaluation) # ユーザー情報を設定
    # 教材は既に登録済み。教材情報のみ登録
    if @material_evaluation.save
      redirect_to materials_path, success: t('material_evaluations.create.success')
    else
      @evaluations = @material.material_evaluations.includes(:comments)
      calculate_material_details(@evaluations) # 教材評価平均、教材評価数、教材特徴
      # ログインユーザー教材情報(教材評価、コメント)
      login_user_evaluation_information(@evaluations)
      # ログインユーザー以外の教材評価とコメントを取得
      @other_evaluations = @evaluations.reject { |evaluation| evaluation.user == current_user }

      flash.now[:danger] = t('material_evaluations.create.danger')
      render :show, status: :unprocessable_entity
    end
  end

  private

  # show用
  def calculate_material_details(evaluations)
    @average_evaluation = evaluations.average(:evaluation).to_f.round(1) # 教材評価平均
    @count_of_unique_evaluators = evaluations.select(:user_id).distinct.count # 教材評価者数
    features = evaluations.pluck(:feature).map { |f| f.split(',') }.flatten # 教材特徴
    @unique_features = features.uniq
  end

  # create用
  def uers_information(material_evaluation)
    material_evaluation.user = current_user
    material_evaluation.comments.each do |comment|
      comment.user = current_user
    end
  end

  # show用
  def login_user_evaluation_information(evaluations)
    # ログインユーザーの評価を取得
    user_evaluation = evaluations.find { |evaluation| evaluation.user == current_user }
    @user_evaluation = user_evaluation&.evaluation
    # ログインユーザーの教材コメントを取得
    @comments = @evaluations.flat_map(&:comments)
    @user_comment = @comments.find { |comment| comment.user == current_user }
  end

  # create用
  def material_evaluation_params
    params.require(:material_evaluation).permit(
      :id, :evaluation, :_destroy,
      { feature: [] },
      { comments_attributes: %i[id body _destroy] }
    )
  end

  def set_material
    @material = Material.find(params[:material_id])
  end
end
