class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :qualifications, dependent: :destroy
  has_many :material_evaluations, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_materials, through: :likes, source: :material
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :password, presence: true, length: { minimum: 4 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, length: { maximum: 100 }
  validates :introduction, length: { maximum: 300 }
  validates :reset_password_token, uniqueness: true, allow_nil: true
  validates :email, presence: true, uniqueness: true

  mount_uploader :image, UserImageUploader

  # 特定の教材をいいねリストに追加する
  def like(material)
    like_materials << material
  end

  # 特定の教材をいいねリストから削除する
  def unlike(material)
    like_materials.destroy(material)
  end

  # いいねリストに特定の教材が含まれているかチェックしている
  def like?(material)
    like_materials.include?(material)
  end
end
