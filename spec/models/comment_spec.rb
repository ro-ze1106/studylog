require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:comment) { create(:comment) }

  context 'バリデーション' do
    it '有効な状態であること' do
      expect(comment).to be_valid
    end

    it 'user_idがなければ無効な状態であること' do
      comment = build(:comment, user_id: nil)
      expect(comment).not_to be_valid
    end

    it 'problem_idがなければ無効な状態であること' do
      comment = build(:comment, problem_id: nil)
      expect(comment).not_to be_valid
    end

    it 'コメントがなければ無効な状態であること' do
      comment = build(:comment, content: nil)
      expect(comment).not_to be_valid
    end

    it 'コメントが100文字以内であること' do
      comment = build(:comment, content: 'あ' * 101)
      comment.valid?
      expect(comment.errors[:content]).to include('は100文字以内で入力してください')
    end
  end
end
