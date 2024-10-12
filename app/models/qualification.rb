class Qualification < ApplicationRecord
  belongs_to :user
  # 中間テーブル
  has_many :material_qualifications, dependent: :destroy
  has_many :material, through: :material_qualifications
  validates :name, presence: true, uniqueness: true
  validates :progress, presence: true
end
