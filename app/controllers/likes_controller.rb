class LikesController < ApplicationController
  def create
    # Materialモデルのmaterial_idを取得する
    @material = Material.find(params[:material_id])
    # いいねを追加するメソッド　Userモデルに定義されている
    current_user.like(@material)
    redirect_to materials_path
  end

  def destroy
    # ログインユーザーが所有するブックマークの中から特定のIDを持つブックマークを探し、そのブックマークに関する掲示板を取得する
    # @material = current_user.likes.find(params[:id]).commentable
    @material = current_user.likes.find(params[:id]).material
    # ブックマークを解除するメソッド　Userモデルに定義されている
    current_user.unlike(@material)
    redirect_to materials_path, status: :see_other
  end
end
