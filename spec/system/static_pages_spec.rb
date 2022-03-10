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

        before do
          login_for_system(user)
        end

        it '問題のページネーションが表示されること' do
          create_list(:problem, 6, user: user)
          visit root_path
          expect(page).to have_content "みんなの問題 (#{user.problems.count})"
          expect(page).to have_css 'div.pagination'
          Problem.take(5).each do |p|
            expect(page).to have_link p.title
          end
        end

        it '「問題作成」のリンクが表示されていること' do
          visit root_path
          expect(page).to have_link '問題作成', href: new_problem_path
        end

        it '問題削除後、削除成功のフラッシュが表示されること' do
          visit root_path
          click_on '削除'
          expect{
            expect(page.accept_confirm).to eq "本当に削除しますか？"
            expect(page).to have_content "問題が削除されました"
            }
        end
      end
    end
  end
end
