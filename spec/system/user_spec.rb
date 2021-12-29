require 'rails_helper'

RSpec.describe 'user', type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }
  let!(:other_problem) { create(:problem, user: other_user) }

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
        Problem.take(5).each do |problem|
          expect(page).to have_content problem.study_type
          expect(page).to have_link problem.title
          expect(page).to have_content problem.explanation_text
          expect(page).to have_content problem.problem_text
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

    it 'トップページからお気に入り登録/解除ができること', js: true do
      visit root_path
      link = find('.like')
      expect(link[:href]).to include "/favorites/#{problem.id}/create"
      link.click
      link = find('.unlike')
      expect(link[:href]).to include "/favorites/#{problem.id}/destroy"
      link.click
      link = find('.like')
      expect(link[:href]).to include "/favorites/#{problem.id}/create"
    end

    it 'ユーザー個別ページからお気に入り登録/解除ができること', js: true do
      visit user_path(user)
      link = find('.like')
      expect(link[:href]).to include "/favorites/#{problem.id}/create"
      link.click
      link = find('.unlike')
      expect(link[:href]).to include "/favorites/#{problem.id}/destroy"
      link.click
      link = find('.like')
      expect(link[:href]).to include "/favorites/#{problem.id}/create"
    end

    it '問題個別ページからお気に入り登録/解除ができること', js: true do
      visit problem_path(problem)
      link = find('.like')
      expect(link[:href]).to include "/favorites/#{problem.id}/create"
      link.click
      link = find('.unlike')
      expect(link[:href]).to include "/favorites/#{problem.id}/destroy"
      link.click
      link = find('.like')
      expect(link[:href]).to include "/favorites/#{problem.id}/create"
    end

    it 'お気に入り一覧ページが期待された通り表示されること' do
      visit favorites_path
      expect(page).not_to have_css 'favorite-problem'
      user.favorite(problem)
      user.favorite(other_problem)
      visit favorites_path
      expect(page).to have_css '.favorite-problem', count: 2
      expect(page).to have_content problem.study_type
      expect(page).to have_content problem.explanation_text
      expect(page).to have_content problem.problem_text
      expect(page).to have_content "作成者 #{user.name}"
      expect(page).to have_link user.name, href: user_path(user)
      expect(page).to have_content other_problem.study_type
      expect(page).to have_content other_problem.explanation_text
      expect(page).to have_content other_problem.problem_text
      expect(page).to have_content "作成者 #{other_user.name}"
      expect(page).to have_link user.name, href: user_path(other_user)
      user.unfavorite(other_problem)
      visit favorites_path
      expect(page).to have_css '.favorite-problem', count: 1
      expect(page).to have_content problem.study_type
    end
  end

  context '通知生成' do
    before do
      login_for_system(user)
    end

    context '自分の問題に対して' do
      before do
        visit problem_path(problem)
      end

      it 'お気に入り登録によって通知が作成されないこと' do
        find('.like').click
        visit problem_path(problem)
        expect(page).to have_css 'li.no_notification'
        visit notifications_path
        expect(page).not_to have_content 'お気に入りに登録されました。'
        expect(page).not_to have_content problem.study_type
        expect(page).not_to have_content problem.problem_text
        expect(page).not_to have_content problem.explanation_text
        expect(page).not_to have_content problem.created_at
      end

      it 'コメントによって通知がされないこと' do
        fill_in "comment_content", with: "コメント"
        click_button "コメント"
        expect(page).to have_css 'li.no_notification'
        visit notifications_path
        expect(page).not_to have_content 'コメントしました'
        expect(page).not_to have_content 'コメント'
        expect(page).not_to have_content problem.study_type
        expect(page).not_to have_content problem.problem_text
        expect(page).not_to have_content problem.explanation_text
        expect(page).not_to have_content problem.created_at
      end
    end

    context '自分以外のユーザーに対して' do
      before do
        visit problem_path(other_problem)
      end

      it 'お気に入りによって通知がされること' do
        find('.like').click
        visit problem_path(other_user)
        expect(page).to have_css 'li.no_notification'
        logout
        login_for_system(other_user)
        expect(page).to have_css 'li.new_notification'
        visit notifications_path
        expect(page).to have_css 'li.no_notification'
        expect(page).to have_content "あなたの問題が#{user.name}さんにお気に入り登録されました。"
        expect(page).to have_content problem.study_type
        expect(page).to have_content problem.problem_text
        expect(page).to have_content problem.explanation_text
        expect(page).to have_content problem.created_at.strftime("%Y/%m/%d(%a) %H:%M")
      end

      it 'コメントによって通知されること' do
        fill_in "comment_content", with: "コメント"
        click_button "コメント"
        expect(page).to have_css 'li.no_notification'
        logout
        login_for_system(other_user)
        expect(page).to have_css 'li.new_notification'
        visit notifications_path
        expect(page).to have_css 'li.no_notification'
        expect(page).to have_content "あなたの問題に#{user.name}さんがコメントしました。"
        expect(page).to have_content '「コメント」'
        expect(page).to have_content problem.study_type
        expect(page).to have_content problem.problem_text
        expect(page).to have_content problem.explanation_text
        expect(page).to have_content problem.created_at.strftime("%Y/%m/%d(%a) %H:%M")
      end
    end
  end
end