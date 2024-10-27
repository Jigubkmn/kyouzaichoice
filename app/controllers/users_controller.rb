class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id # オートログイン
      redirect_to materials_path, success: t('users.create.success')
    else
      flash.now[:danger] = t('users.create.danger')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :introduction, :image, :image_cache)
  end

  def session_params
    params.require(:user).permit(:name)
  end
end
