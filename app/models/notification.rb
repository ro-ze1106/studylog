class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :problem
  validates :user_id, presence: true
  validates :problem_id, presence: true
  validates :variety, presence: true
  validates :from_user_id, presence: true
  default_scope -> { order(created_at: :desc) }
end
