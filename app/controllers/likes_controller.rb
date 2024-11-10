class LikesController < ApplicationController
  def create
    @material = Material.find(params[:material_id])
    # いいねを追加するメソッド
    current_user.like(@material)
    redirect_to request.referer, status: :see_other
  end

  def destroy
    # ログインユーザーが所有するいいねの中から特定のIDを持ついいねを探し、そのいいねに関する教材を取得する
    @material = current_user.likes.find(params[:id]).material
    # いいねを解除するメソッド
    current_user.unlike(@material)
    redirect_to request.referer, status: :see_other
  end
end
