class MaterialEvaluation < ApplicationRecord
  belongs_to :user
  belongs_to :material
  has_many :comments, as: :commentable, dependent: :destroy

  validates :evaluation, presence: true

  # データを同時に保存する
  accepts_nested_attributes_for :comments, allow_destroy: true

  def self.ransackable_attributes(_auth_object = nil)
    %i[feature created_at id updated_at]
  end
end
