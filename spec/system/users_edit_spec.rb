require 'rails_helper'

RSpec.describe 'users_edit', type: :system do
  let!(:user) { create (:user) }

  describe 'プロフィール編集ページ' do
    before do
      login_for_system(user)
      visit user_path(user)
      click_link 'プロフィール編集' 
    end

    it '有効なプロフィール編集を行うと、編集成功のフラッシュが表示されること' do
      fill_in 'ユーザー名', with: 'test'
      fill_in 'メールアドレス', with: 'example@example.com'
      fill_in 'パスワード', with: 'passpass'
      fill_in '確認用パスワード', with: 'passpass'
      click_button "更新する"
      expect(page).to have_content 'プロフィールの編集が完了しました。'
    end

    it '無効なプロフィール編集を行うと、編集失敗のフラッシュが表示されること' do
      fill_in 'ユーザー名', with: ''
      fill_in 'メールアドレス', with: ''
      click_button "更新する"
      expect(page).to have_content 'ユーザー名を入力してください'
      expect(page).to have_content 'メールアドレスを入力してください'
      expect(page).to have_content 'メールアドレスは不正な値です'
    end
  end
end