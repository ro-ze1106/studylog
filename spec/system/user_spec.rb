require 'rails_helper'

RSpec.describe 'user', type: :system do
  let!(:user) { create(:user) }

  describe 'ユーザー登録ページ' do
    before do
      visit signup_path
    end

    context 'ページレイアウト' do
      it '「ユーザー登録」の文字列が存在すること' do
        expect(page).to have_content 'ユーザー登録'
      end

      it '正しいタイトルが表示されることを確認' do
        expect(page).to have_title full_title('ユーザー登録')
      end
    end

    context 'ユーザー登録処理' do
      it '有効なユーザーでユーザー登録を行うと登録成功のフラッシュメッセージが表示されること' do
        fill_in 'ユーザー名', with: 'User'
        fill_in 'メールアドレス', with: 'user@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in '確認用パスワード', with: 'password'
        click_button '登録する'
        expect(page).to have_content 'スタディログへようこそ'
      end

      it '無効なユーザーでユーザー登録を行うと登録失敗のフラッシュメッセージが表示されること' do
        fill_in 'ユーザー名', with: ''
        fill_in 'メールアドレス', with: 'user@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in '確認用パスワード', with: 'pass'
        click_button '登録する'
        expect(page).to have_content 'ユーザー名を入力してください'
        expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
      end
    end
  end

  describe 'プロフィールページ' do
    context 'ページレイアウト' do
      before do
        login_for_system(user)
        visit user_path(user)
      end

      it '「プロフィール」の文字列が存在すること' do
        expect(page).to have_content 'プロフィール'
      end

      it '正しいタイトルが表示されること' do
        expect(page).to have_title full_title('プロフィール')
      end

      it 'ユーザー情報が表示されること' do
        expect(page).to have_content user.name
      end

      it 'プロフィール編集ページのリンクが表示されていること' do
        expect(page).to have_link 'プロフィール編集', href: edit_user_path(user)
      end
    end
  end
end
