class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    # 指定されたプロバイダの認証ページにユーザーをリダイレクトさせる
    login_at(auth_params[:provider])
  end

  def callback
    if params[:error].present?
      # ユーザーが認証をキャンセルした場合の処理
      redirect_to root_path, danger: '認証がキャンセルされました'
      return
    end
    provider = auth_params[:provider]
    # 既存のユーザーをプロバイダ情報を元に検索し、存在すればログイン
    if (@user = login_from(provider))
      redirect_to materials_path, success: "#{provider.titleize}アカウントでログインしました"
    else
      begin
        # ユーザーが存在しない場合はプロバイダ情報を元に新規ユーザーを作成し、ログインする
        signup_and_login(provider)
        redirect_to materials_path, success: "#{provider.titleize}アカウントでログインしました"
      rescue StandardError
        redirect_to root_path, danger: "#{provider.titleize}アカウントでのログインに失敗しました"
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end

  def signup_and_login(provider)
    @user = create_from(provider)
    reset_session
    auto_login(@user)
  end
end
