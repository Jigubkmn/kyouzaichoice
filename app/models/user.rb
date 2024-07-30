class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 4 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, length: { maximum: 100 }
  validates :introduction, length: { maximum: 300 }
  validates :email, presence: true, uniqueness: true
end