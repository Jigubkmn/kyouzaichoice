class ProfileUsersController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t('profile_users.update.success')
      redirect_to profile_user_path
    else
      flash.now['danger'] = t('profiles.update.danger')
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:email, :name, :introduction, :image, :image_cache)
  end
end