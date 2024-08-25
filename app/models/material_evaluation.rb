class MaterialEvaluation < ApplicationRecord
  belongs_to :user
  belongs_to :material
  has_many :comments, as: :commentable, dependent: :destroy

  validates :evaluation, presence: true

  # データを同時に保存する
  accepts_nested_attributes_for :comments, allow_destroy: true
end
