class Problem < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_one_attached :picture
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
  validates :picture, content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: '画像の拡張子をjpegかgifかpngにして下さい。' },
                      size: { less_than: 5.megabytes,
                              message: 'は5MBより大きい画像はアップロードできません。' }

  def display_picture
    picture.variant(resize_to_limit: [200, 200])
  end

  # 問題に付属するコメントのフィードを作成
  def feed_comment(problem_id)
    Comment.where('problem_id = ?', problem_id)
  end
end
