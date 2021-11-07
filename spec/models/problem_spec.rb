require 'rails_helper'

RSpec.describe Problem, type: :model do
  let!(:problem_yesterday) { create(:problem, :yesterday) }
  let!(:problem_one_week_ago) { create(:problem, :one_week_ago) }
  let!(:problem_one_month_ago) { create(:problem, :one_month_ago) }
  let!(:problem) { create(:problem) }
 
  context 'バリデーション' do
    it '有効な状態であること' do
      expect(problem).to be_valid
    end

    it '科目がなければ無効であること' do
      problem = build(:problem, study_type: nil)
      problem.valid?
      expect(problem.errors[:study_type]).to include
    end

    it '科目が30文字以内じゃないと無効であること' do
      problem = build(:problem, study_type: 'a' * 31)
      problem.valid?
      expect(problem.errors[:study_type]).to include
    end

    it 'タイトル名がなければ無効であること' do
      problem = build(:problem, title: nil)
      problem.valid?
      expect(problem.errors[:title]).to include
    end

    it '問題文がなければ無効なこと' do
      problem = build(:problem, problem_text: nil)
      problem.valid?
      expect(problem.errors[:problem_text]).to include
    end

    it '答えがなければ無効であること' do
      problem = build(:problem, answer: nil)
      problem.valid?
      expect(problem.errors[:answer]).to include
    end

    it '年齢対象が7以上でなければ無効であること' do
      problem = build(:problem, target_age: 6)
      problem.valid?
      expect(problem.errors[:taget_age]).to include
    end

    it '年齢対象が18以下でなければ無効であること' do
      problem = build(:problem, target_age: 19)
      problem.valid?
      expect(problem.errors[:taget_age]).to include
    end

    it "ユーザーIDがなければ無効な状態であること" do
      problem = build(:problem, user_id: nil)
      problem.valid?
      expect(problem.errors[:user_id]).to include
    end
  end

  context "並び順" do
    it '最近の投稿が最初の投稿になっていること' do
      expect(problem).to eq Problem.first
    end
  end
end
