require 'rails_helper'

RSpec.describe 'StaticPages', type: :system do
  describe 'トップページ' do
    context 'ページ全体' do
      before do
        visit root_path
      end

      it 'スタディログの文字列が存在することを確認' do
        expect(page).to have_content 'スタディログ'
      end

      it '正しいタイトルが表示されることを確認' do
        expect(page).to have_title full_title
      end

      context '問題フィード', js: true do
        let!(:user) { create(:user) }
        let!(:problem) { create(:problem, user: user) }

        it '問題のページネーションが表示されること' do
          login_for_system(user)
          create_list(:problem, 6, user: user)
          visit root_path
          expect(page).to have_content "みんなの問題 (#{user.problems.count})"
          expect(page).to have_css "div.pagination"
          Problem.take(5).each do |p|
            expect(page).to have_link p.study_type
          end
        end
      end
    end
  end 
end
