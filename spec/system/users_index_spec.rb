require 'rails_helper'

RSpec.describe 'users_index', type: :system do
  let!(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }

  describe 'ユーザー一覧ページ' do
    context '管理者ユーザーの場合' do
      it 'ページネーション、自分以外のユーザーの削除ボタンが表示されること' do
        create_list(:user, 30)
        login_for_system(admin_user)
        visit users_path
        expect(page).to have_css 'div.pagination'
        User.paginate(page: 1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          expect(page).to have_content "#{u.name} | 削除" unless u == admin_user
        end
      end
    end

    context '管理者ユーザー以外の場合' do
      it 'ページネーション、自分のアカウントのみ削除ボタンが表示されること' do
        create_list(:user, 30)
        login_for_system(user)
        visit users_path
        expect(page).to have_css 'div.pagination'
        User.paginate(page: 1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          if u == user
            expect(page).to have_content "#{u.name} | 削除する"
          else
            expect(page).not_to have_content "#{u.name} |削除する"
          end
        end
      end
    end
  end

    context 'アカウント削除処理', js: true do
      it 'ユーザー一覧から削除できること' do
        login_for_system(user)
        visit users_path
        click_link '削除する'
        expect{
        expect(page.accept_confirm).to eq "本当に削除しますか？"
        expect(page).to have_content "自分のアカウントを削除しました"
        }
      end
    end
end
