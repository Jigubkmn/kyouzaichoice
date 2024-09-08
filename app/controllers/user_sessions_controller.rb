class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create guest_login]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to materials_path, success: t('user_sessions.create.success')
    else
      @user = User.new(email: params[:email])
      flash.now[:danger] = t('user_sessions.create.danger')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, success: t('user_sessions.destroy.success')
  end

  def guest_login
    rondom_value = SecureRandom.alphanumeric(10) + Time.zone.now.to_i.to_s
    @guest_user = User.create(
      name: 'GuestUser',
      # email: rondom_value + '@example.com',
      email: "#{rondom_value}@example.com",
      password: 'password',
      password_confirmation: 'password'
    )
    id = @guest_user.id
    @guest_user.update!(name: "GuestUser_#{id}")
    auto_login(@guest_user)
    redirect_back_or_to root_path, success: 'ゲストとしてログインしました'
  end
end
