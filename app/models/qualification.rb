class Qualification < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, uniqueness: true
  validates :progress, presence: true
end
