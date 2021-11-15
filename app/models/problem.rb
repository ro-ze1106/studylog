class Problem < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :study_type, presence: true, length: { maximum: 30 }
  validates :title, presence: true
  validates :problem_text, presence: true
  validates :answer, presence: true
  validates :target_age,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 7,
              less_than_or_equal_to: 18
            },
            allow_nil: true
end
