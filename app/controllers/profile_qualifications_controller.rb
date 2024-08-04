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
      redirect_to profile_qualifications_path, success: '資格を作成しました'
    else
      @qualifications = Qualification.all
      puts @qualification.errors.full_messages 
      flash.now['danger'] = '資格を作成出来ませんでした'
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit; end

  def update
    if @qualification.update(qualification_params)
      redirect_to profile_user_path, notice: '資格を更新されました'
    else
      flash.now['danger'] = '資格を更新出来ませんでした'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    qualification = current_user.qualifications.find(params[:id])
    qualification.destroy
    redirect_to profile_qualifications_path, success: '資格が削除されました'
  end

  private
  
  def set_qualification
    @qualification = Qualification.find(params[:id])
  end

  def qualification_params
    params.require(:qualification).permit(:name, :progress, :year_acquired) # 必要に応じてフィールドを調整
  end

end
