class MaterialsController < ApplicationController
  before_action :require_login, except: %i[index]
  before_action :set_material, only: %i[edit update destroy]

  def new
    # 既に登録済みの教材かチェック
    @existing_material = Material.find_by(title: material_params[:title], systemid: material_params[:systemid])
    # 既に登録済みの教材&ログインユーザーが評価済みの場合
    if @existing_material&.material_evaluations&.exists?(user: current_user)
      login_material_evaluations # ログインユーザーに関連するMaterialEvaluationを取得
      flash.now[:danger] = t('materials.new.danger')
      render :already_registered, status: :unprocessable_entity
      return
    # 対象教材が他のユーザーによって登録されている場合
    elsif @existing_material
      @material = @existing_material
      @material_evaluation = @material.material_evaluations.build(user: current_user)
      redirect_to new_material_material_evaluation_path(@material.id).where(user: current_user) # MaterialEvaluationコントローラーのnewアクションにリクエストする
    else
      @material = Material.new(material_params)
      @material.material_evaluations.build(user: current_user)
      @qualifications = Qualification.where(user: current_user).pluck(:name) # Qualificationテーブルのnameを配列として取得
    end
  end

  def index
    @q = Material.ransack(params[:q])
    @materials = @q.result(distinct: true)
                   .includes(:material_evaluations)
                   .select('materials.*, published_date IS NULL AS is_null')
                   .page(params[:page])
                   .per(10)
    # 並び替え処理
    @materials = case params[:sort]
                 when 'published_date'
                   @materials.order_by_published_date # 公開日の新しい順
                 when 'evaluation'
                   @materials.order_by_evaluation_average # 評価が高い順
                 else
                   @materials
                 end
    @materials_with_details = @materials.map do |material|
      material_contents(material)
    end
  end

  # オートコンプリート
  def index_autocomplete
    @materials = Material.where('title like ?', "%#{params[:q]}%")
    render partial: 'materials/index_autocomplete'
  end

  # プロフィール(教材) 登録済み
  def already_registered
    login_material_evaluations # ログインユーザーに関連するMaterialEvaluationを取得
  end

  # プロフィール(教材) いいね
  def like
    @q = current_user.like_materials.ransack(params[:q])
    @materials = @q.result(distinct: true)
                   .includes(material_evaluations: [:user])
                   .select('materials.*, published_date IS NULL AS is_null')
                   .page(params[:page])
                   .per(10)
                   .order(Arel.sql('is_null, published_date DESC')) # published_dateがnilのデータは並び替えで一番最後に表示させる
    @materials_with_details = @materials.map do |material|
      material_contents(material)
    end
  end

  # 教材登録時の検索
  def search
    if params[:search].nil?
      return
    elsif params[:search].blank?
      flash.now[:danger] = t('materials.search.danger')
      return
    else
      url = ENV.fetch('GOOGLE_BOOKS_API_URL')
      text = params[:search]
      api_key = ENV.fetch('GOOGLE_BOOKS_API_KEY')
      res = Faraday.get(url, q: text, langRestrict: 'ja', maxResults: 30, orderBy: 'relevance', key: api_key)
      @google_materials = JSON.parse(res.body)
    end
  end

  def create
    @material = Material.new(material_params)
    uers_information(@material)
    # featureカラムの処理
    first_evaluation = @material.material_evaluations.first
    process_features(first_evaluation)
    if @material.save
      redirect_to already_registered_materials_path, success: t('materials.create.success')
    else
      flash.now[:danger] = t('materials.create.danger')
      @qualifications = Qualification.where(user: current_user).pluck(:name) # Qualificationテーブルのnameを配列として取得
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # ログインユーザーに関連するMaterialEvaluationとコメントのみを読み込む
    @material_evaluation = @material.material_evaluations.where(user: current_user)
    @qualifications = Qualification.where(user: current_user).pluck(:name) # Qualificationテーブルのnameを配列として取得
  end

  def update
    @material_evaluations = @material.material_evaluations.find_by(user: current_user)
    features = material_evaluation_params[:feature] || [] # material_evaluation_paramsからfeatureを取得し、デフォルトは空配列
    if features.empty? # featureが空の場合は空文字列を追加
      @material_evaluations.feature = '' # 空文字列を@material_evaluationsに設定
    end
    if @material.update(material_params) && @material_evaluations.update(material_evaluation_params)
      process_features(@material_evaluations) # 配列をカンマ潜りの文字列に変換
      @material_evaluations.save # 変換後のデータを保存
      redirect_to already_registered_materials_path, success: t('materials.update.success')
    else
      flash.now[:danger] = t('materials.update.danger')
      @qualifications = Qualification.where(user: current_user).pluck(:name) # Qualificationテーブルのnameを配列として取得
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @material = Material.find(params[:id])
    # ログインユーザーが作成したmaterial_evationを取得
    user_evaluations = @material.material_evaluations.where(user: current_user)
    return unless user_evaluations.exists?

    # ログインユーザーが作成したMaterialEvaluationとそのコメントを削除
    user_evaluations.each(&:destroy)
    # 他のユーザーによる評価がない場合、Material自体を削除
    @material.destroy if @material.material_evaluations.empty?
    redirect_to already_registered_materials_path, success: t('materials.destroy.success')
  end

  private

  # index用
  def calculate_material_details(evaluations)
    @average_evaluation = evaluations.average(:evaluation).to_f.round(1) # 教材評価平均
    @count_of_unique_evaluators = evaluations.select(:user_id).distinct.count # 教材評価者数
    features = evaluations.pluck(:feature).map { |f| f.split(',') }.flatten # 教材特徴
    @unique_features = features.uniq
  end

  # index、like用
  def material_contents(material)
    @evaluations = material.material_evaluations
    calculate_material_details(@evaluations) # 教材評価平均、教材評価数、教材特徴
    comments_count = @evaluations.where.not(body: nil).count # 各教材に関連する評価のコメント数を計算
    like_count = material.likes.count # いいね数
    material.as_json.merge(
      average_evaluation: @average_evaluation,
      count_of_unique_evaluators: @count_of_unique_evaluators,
      unique_features: @unique_features,
      comments_count:,
      like_count:
    )
  end

  # create、update用
  def process_features(evaluation)
    return if evaluation.feature.blank?

    # JSON配列形式の文字列をRubyの配列に変換し、その後カンマ区切りの文字列に変換
    features_array = JSON.parse(evaluation.feature)
    evaluation.feature = features_array.join(',')
  end

  # new用、already_registered用
  def login_material_evaluations
    @material_evaluations = current_user.material_evaluations
                                        .joins(:material)
                                        .select('material_evaluations.*, materials.*, published_date IS NULL AS is_null')
                                        .page(params[:page])
                                        .per(10)
                                        .order(Arel.sql('is_null, published_date DESC')) # published_dateがnilのデータは並び替えで一番最後に表示させる
    @materials = @material_evaluations.map(&:material).uniq # 対象materialデータ表示
  end

  # ユーザー情報を設定
  def uers_information(material)
    # MaterialEvaluationにuser_idを設定
    material.material_evaluations.each do |evaluation|
      evaluation.user = current_user
    end
  end

  # new,create,update用
  def material_params
    params.require(:material).permit(
      :title, :image_link, :published_date, :info_link, :systemid, :publisher, :description, :qualification,
      material_evaluations_attributes: [
        :id, :evaluation, :body, :_destroy, { feature: [] }
      ]
    )
  end

  # update
  def material_evaluation_params
    params.require(:material).permit(
      material_evaluations_attributes: [
        :id, :evaluation, :body, :_destroy, { feature: [] }
      ]
    )[:material_evaluations_attributes]['0']
  end

  def set_material
    @material = Material.find(params[:id])
  end
end
