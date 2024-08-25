class Material < ApplicationRecord
  has_many :material_evaluations, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :image_link, presence: true, uniqueness: true
  # データを同時に保存する
  accepts_nested_attributes_for :material_evaluations, reject_if: :all_blank, allow_destroy: true
end
