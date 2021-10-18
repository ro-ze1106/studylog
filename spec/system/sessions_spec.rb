require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  describe 'ログインページ' do
  let!(:user) { create(:user) }

  before do
    visit login_path
  end

    it '「ログイン」という文字列が存在すること' do
      expect(page).to have_content 'ログイン'
    end

    it '正しいタイトルが表示されることを確認' do
      expect(page).to have_title full_title('ログイン')
    end

    it 'ヘッダーにログインのリンクが存在すること' do
      expect(page).to have_link 'ログイン', href: login_path
    end

    it 'ログインフォームのラベルが正しく表示されていること' do
      expect(page).to have_content 'メールアドレス'
      expect(page).to have_content 'パスワード'
    end

    it '「自動ログインにする」チェックボックスが表示されていること' do
      expect(page).to have_content '自動ログインにする'
    end

    it 'ログインボタンが正しく表示されていること' do
      expect(page).to have_button 'ログイン'
    end

    it '有効なユーザーでログインを行うと成功すること' do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'ログインする'
      expect(page).to have_http_status :ok
    end

    it '無効なユーザーでログインを行うと失敗すること' do
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: 'pass'
      click_button 'ログインする'
      expect(page).to have_content 'メールアドレスまたはパスワードが間違っています'

      visit root_path
      expect(page).to_not have_content 'メールアドレスまたはパスワードが間違っています'
    end

    it '有効なユーザーでログインする前後でヘッダーが正しく表示されること' do
      expect(page).to have_link 'スタディログとは？', href: about_path
      expect(page).to have_link 'ユーザー登録', href: signup_path
      expect(page).to have_link 'ログイン', href: login_path
      expect(page).not_to have_link 'ログアウト', href: logout_path

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'ログインする'

      expect(page).to have_link 'スタディログとは？', href: about_path
      expect(page).to have_link 'ユーザー一覧', href: users_path
      expect(page).to have_link 'プロフィール', href: user_path(user)
      expect(page).to have_link 'ログアウト', href: logout_path
      expect(page).not_to have_link 'ログイン', href: login_path
    end
  end
end
