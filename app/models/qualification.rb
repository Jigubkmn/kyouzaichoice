class Qualification < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :progress, presence: true
end
