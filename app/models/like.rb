class Like < ApplicationRecord
  belongs_to :user
  belongs_to :material
  # belongs_to :commentable, polymorphic: true

  # validates :user_id, uniqueness: { scope: %i[commentable_type commentable_id] }
end
