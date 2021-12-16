require 'rails_helper'

RSpec.describe 'user', type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }

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
        create_list(:problem, 10, user: user)
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

      it '問題の件数が表示されていること' do
        expect(page).to have_content "問題 (#{user.problems.count})"
      end

      it '問題の情報が表示されていること' do
        Problem.take(7).each do |problem|
          expect(page).to have_content problem.study_type
          expect(page).to have_link problem.title
          expect(page).to have_content problem.explanation_text
          expect(page).to have_content problem.problem_text
          expect(page).to have_content problem.answer
          expect(page).to have_content problem.problem_explanation
          expect(page).to have_content problem.target_age
        end
      end

      it '問題のページネーションが表示されていること' do
        expect(page).to have_css 'div.pagination'
      end
    end
  end

  context 'ユーザーのフォロー/アンフォロー処理', js: true do
    it 'ユーザーのフォロー/アンフォローができること' do
      login_for_system(user)
      visit user_path(other_user)
      expect(page).to have_button 'フォローする'
      click_button 'フォローする'
      expect(page).to have_button 'フォロー中'
      click_button 'フォロー中'
      expect(page).to have_button 'フォローする'
    end
  end

  context 'お気に入り登録/解除' do
    before do
      login_for_system(user)
    end

    it '問題のお気に入り登録/解除ができること' do
      expect(user.favorite?(problem)).to be_falsey 
      user.favorite(problem)
      expect(user.favorite?(problem)).to be_truthy 
      user.unfavorite(problem)
      expect(user.favorite?(problem)).to be_falsey
    end
  end
end
