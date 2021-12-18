class Comment < ApplicationRecord
belongs_to :problem
validates :user_id, presence: true
validates :problem_id, presence: true
validates :content, presence: true, length: { maximum: 100 }
end
