require 'rails_helper'

RSpec.describe "problems_search", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }

  context '検索機能' do
    context 'ログインしている場合' do
      before do
        login_for_system(user)
        visit root_path
      end

      it 'ログイン後の各ページに検索窓が表示されること' do
        expect(page).to have_css 'form#problem_search'
        visit about_path
        expect(page).to have_css 'form#problem_search'
        visit use_of_terms_path
        expect(page).to have_css 'form#problem_search'
        visit users_path
        expect(page).to have_css 'form#problem_search'
        visit user_path(user)
        expect(page).to have_css 'form#problem_search'
        visit edit_user_path(user)
        expect(page).to have_css 'form#problem_search'
        visit problems_path
        expect(page).to have_css 'form#problem_search'
        visit problem_path(problem)
        expect(page).to have_css 'form#problem_search'
        visit new_problem_path(problem)
        expect(page).to have_css 'form#problem_search'
        visit edit_problem_path(problem)
        expect(page).to have_css 'form#problem_search'
        visit following_user_path(user)
        expect(page).to have_css 'form#problem_search'
        visit followers_user_path(user)
        expect(page).to have_css 'form#problem_search'
      end

      it 'フィードの中から検索ワードに該当する結果が表示されること' do
        create(:problem, study_type: '理科', user: user)
        create(:problem, study_type: '理科1', user: other_user)
        create(:problem, title: '記号問題', user: user)
        create(:problem, title: '記号問題1', user: other_user)
        create(:problem, target_age: '13', user: user)
        create(:problem, target_age: '13', user: other_user)

        # 誰もフォローしない場合
        fill_in 'q_study_type_or_title_or_target_age_cont', with: '理科'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”理科”の検索結果：1件"
        within find('.problems') do
          expect(page).to have_css 'li', count: 1
        end
        fill_in 'q_study_type_or_title_or_target_age_cont', with: '記号問題'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”記号問題”の検索結果：1件"
        within find('.problems') do
          expect(page).to have_css 'li', count: 1
        end
        fill_in 'q_study_type_or_title_or_target_age_cont', with: '13'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”13”の検索結果：1件"
        within find('.problems') do
          expect(page).to have_css 'li', count: 1
        end

        # other_userをフォローする場合
        user.follow(other_user)
        fill_in 'q_study_type_or_title_or_target_age_cont', with: '理科'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”理科”の検索結果：2件"
        within find('.problems') do
          expect(page).to have_css 'li', count: 2
        end
        fill_in 'q_study_type_or_title_or_target_age_cont', with: '記号問題'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”記号問題”の検索結果：2件"
        within find('.problems') do
          expect(page).to have_css 'li', count: 2
        end
        fill_in 'q_study_type_or_title_or_target_age_cont', with: '13'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”13”の検索結果：2件"
        within find('.problems') do
          expect(page).to have_css 'li', count: 2
        end
      end

      it '検索ワードを入れずに検索ボタンを押した場合、問題一覧ページが用事されること' do
        fill_in 'q_study_type_or_title_or_target_age_cont', with: ''
        click_button '検索'
        expect(page).to have_css 'h3', text: "問題一覧"
        within find('.problems') do
          expect(page).to have_css 'li', count: Problem.count
        end
      end
    end

    context 'ログインしていない場合' do
      it '検索窓が表示されない' do
        visit root_path
        expect(page).not_to have_css 'form#problem_search'
      end
    end
  end
end
