class MaterialEvaluation < ApplicationRecord
  belongs_to :user
  belongs_to :material
  validates :evaluation, presence: true
  validates :feature, presence: true
end
