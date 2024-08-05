class ProfileQualificationsController < ApplicationController
  before_action :require_login
  before_action :set_qualification, only: [:edit, :update, :destroy]
  
  def new
    @qualification = Qualification.new
  end  

  def index
    @qualifications = Qualification.all
  end

  def create
    @qualification = current_user.qualifications.build(qualification_params)
    if @qualification.save
      redirect_to profile_qualifications_path, success: t('profile_qualifications.create.success')
    else
      @qualifications = Qualification.all
      flash.now['danger'] = t('profile_qualifications.create.danger')
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit; end

  def update
    if @qualification.update(qualification_params)
      redirect_to profile_qualifications_path, success: t('profile_qualifications.update.success')
    else
      flash.now['danger'] = t('profile_qualifications.update.danger')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    qualification = current_user.qualifications.find(params[:id])
    qualification.destroy
    redirect_to profile_qualifications_path, success: t('profile_qualifications.destroy.success')
  end

  private
  
  def set_qualification
    @qualification = Qualification.find(params[:id])
  end

  def qualification_params
    params.require(:qualification).permit(:name, :progress, :year_acquired) # 必要に応じてフィールドを調整
  end

end
