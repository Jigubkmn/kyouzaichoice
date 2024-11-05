class ProfilesController < ApplicationController
  before_action :set_user, only: %i[index edit update]

  def index; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to qualifications_path, success: t('profiles.update.success')
    else
      flash.now['danger'] = t('profiles.update.danger')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:email, :name, :introduction, :image, :image_cache)
  end
end
