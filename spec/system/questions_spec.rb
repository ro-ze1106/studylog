require 'rails_helper'

RSpec.describe 'Questions', type: :system do
  let!(:user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }

  describe '問題出題ページ' do
    before do
      login_for_system(user)
      visit question_path(problem)
    end

    context 'レイアウトページ' do
      it '正しいタイトルが表示されていること' do
        expect(page).to have_title full_title('問題')
      end

      it '必要な問題(problem)情報が表示されていること' do
        expect(page).to have_content problem.study_type
        expect(page).to have_content problem.explanation_text
        expect(page).to have_content problem.problem_text
      end
    end

    context '問題解答の処理' do
      it '有効な情報で問題出題を行うと成功のフラッシュが表示されること' do
        fill_in '答え', with: '94'
        click_button '答え合わせ'
        expect(page).to have_content '当たり'
      end

      it '無効な情報で問題出題を行うと失敗のフラッシュが表示されること' do
        fill_in '答え', with: '0'
        click_button '答え合わせ'
        expect(page).to have_content 'はずれ'
      end
    end
  end
end
