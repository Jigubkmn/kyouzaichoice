class MaterialEvaluationsController < ApplicationController
  before_action :require_login, except: %i[show]
  before_action :set_material, only: %i[new show create]

  def new
    @material_evaluation = @material.material_evaluations.build(user: current_user)
  end

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
    @material_evaluation.user = current_user # ユーザー情報を設定
    process_features(@material_evaluation) # featureカラムの処理
    # 教材は既に登録済み。教材情報のみ登録
    if @material_evaluation.save
      redirect_to materials_path, success: t('material_evaluations.create.success')
    else
      source_view = params[:material_evaluation][:source_view]
      if source_view == 'new' # 登録済み教材ページから教材登録する場合
        flash.now[:danger] = t('material_evaluations.create.danger')
        render :new, status: :unprocessable_entity
      elsif source_view == 'show' # 教材詳細ページから教材登録する場合
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
  end

  private

  # show用
  def calculate_material_details(evaluations)
    @average_evaluation = evaluations.average(:evaluation).to_f.round(1) # 教材評価平均
    @count_of_unique_evaluators = evaluations.select(:user_id).distinct.count # 教材評価者数
    features = evaluations.pluck(:feature).map { |f| f.split(',') }.flatten # 教材特徴
    @unique_features = features.uniq
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
      :id, :evaluation, :body, :_destroy,
      { feature: [] }
    )
  end

  # create用
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
