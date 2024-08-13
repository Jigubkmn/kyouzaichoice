class MaterialEvaluation < ApplicationRecord
  belongs_to :user
  belongs_to :material
  has_many :comments, as: :commentable

  validates :evaluation, presence: true
  validates :feature, presence: true
  # データを同時に保存する
  accepts_nested_attributes_for :comments, reject_if: :all_blank, allow_destroy: true
end
