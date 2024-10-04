class MaterialEvaluation < ApplicationRecord
  belongs_to :user
  belongs_to :material

  validates :evaluation, presence: true
  validates :body, presence: true, length: { maximum: 500 }

  def self.ransackable_attributes(_auth_object = nil)
    %i[feature created_at id updated_at]
  end
end
