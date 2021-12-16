class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :problem
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :problem_id, presence: true
end
