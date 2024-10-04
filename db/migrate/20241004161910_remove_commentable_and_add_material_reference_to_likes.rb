class RemoveCommentableAndAddMaterialReferenceToLikes < ActiveRecord::Migration[7.0]
  def change
    # commentableカラムを削除
    remove_reference :likes, :commentable, polymorphic: true, index: true

    # material_idカラムを追加
    add_reference :likes, :material, foreign_key: true
  end
end
