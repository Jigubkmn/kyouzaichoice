class MaterialEvaluationsController < ApplicationController
  before_action :require_login, except: %i[show]
  before_action :set_material, only: %i[new show create]

  def new
    @material_evaluation = @material.material_evaluations.build(user: current_user)
  end

  def show
    @material_evaluation = @material.material_evaluations.build
    @evaluations = @material.material_evaluations.includes(:user)
    # 教材評価平均、教材評価数、教材特徴
    calculate_material_details(@evaluations)
    # ログインユーザー教材情報(教材評価、コメント)
    login_user_evaluation_information(@evaluations)
    # ログインユーザー以外の教材評価とコメントを取得
    @other_evaluations = @evaluations.reject { |evaluation| evaluation.user == current_user }
  end

  def create
    @material_evaluation = @material.material_evaluations.build(material_evaluation_params)
    @material_evaluation.user = current_user
    # featureカラムの処理
    process_features(@material_evaluation)
    # 教材は既に登録済み。教材評価のみ登録
    if @material_evaluation.save
      redirect_to materials_path, success: t('material_evaluations.create.success')
    else
      source_view = params[:material_evaluation][:source_view]
      # 登録済み教材ページから教材登録する場合
      if source_view == 'new'
        flash.now[:danger] = t('material_evaluations.create.danger')
        render :new, status: :unprocessable_entity
      # 教材詳細ページから教材登録する場合
      elsif source_view == 'show'
        @evaluations = @material.material_evaluations.includes(:user)
        # 教材評価平均、教材評価数、教材特徴
        calculate_material_details(@evaluations)
        # ログインユーザー教材情報(教材評価、コメント)
        login_user_evaluation_information(@evaluations)
        # ログインユーザー以外の教材評価とコメントを取得
        @other_evaluations = @evaluations.reject { |evaluation| evaluation.user == current_user }
        flash.now[:danger] = t('material_evaluations.create.danger')
        render :show, status: :unprocessable_entity
      end
    end
  end

  private

  def calculate_material_details(evaluations)
    # 教材評価平均
    @average_evaluation = evaluations.average(:evaluation).to_f.round(1)
    # 教材評価者数
    @count_of_unique_evaluators = evaluations.select(:user_id).distinct.count
    # 教材特徴
    features = evaluations.pluck(:feature).map { |f| f.split(',') }.flatten
    @unique_features = features.uniq
  end

  def login_user_evaluation_information(evaluations)
    # ログインユーザーの評価を取得
    user_evaluation = evaluations.find { |evaluation| evaluation.user == current_user }
    @user_evaluation = user_evaluation&.evaluation
    @body = evaluations.map(&:body)
    @user_body = user_evaluation&.body
  end

  def material_evaluation_params
    params.require(:material_evaluation).permit(
      :id, :evaluation, :body, :_destroy,
      { feature: [] }
    )
  end

  def process_features(material_evaluations)
    return unless material_evaluations.feature.present?

    # JSON配列形式の文字列をRubyの配列に変換し、その後カンマ区切りの文字列に変換
    features_array = JSON.parse(material_evaluations.feature)
    material_evaluations.feature = features_array.join(',')
  end

  def set_material
    @material = Material.find(params[:material_id])
  end
end
