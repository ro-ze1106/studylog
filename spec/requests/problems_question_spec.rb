require 'rails_helper'

RSpec.describe '問題出題', type: :request do
  let!(:user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }

  context '認可されたユーザーの場合' do
    it 'レスポンスが正常に表示されること' do
      login_for_request(user)
      get question_problem_path(problem)
      expect(response).to have_http_status '200'
      expect(response).to render_template('problems/question')
    end
  end

  context 'ログインされていないユーザーの場合' do
    it '採用担当者ログイン画面にリダイレクトされること' do
    get question_problem_path(problem)
    expect(response).to have_http_status '302'
    expect(response).to redirect_to recruit_login_path
    end
  end

  context '問題の答えが正解だった場合' do
    it 'ホームページにリダイレクトされること' do
      login_for_request(user)
      get question_problem_path(problem)
      patch answer_problem_path(problem), params: { problem: { answer: 94 } }
      expect(response).to redirect_to root_path
    end
  end

  context '問題が答えが不正解だった場合' do
    it 'レスポンスが正常に表示されること' do
      login_for_request(user)
      get question_problem_path(problem)
      patch answer_problem_path(problem), params: { problem: { answer: 0 } }
      expect(response).to render_template('problems/question')
    end
  end

  context 'answerページに戻った場合' do
    it 'ホームページにリダイレクトされること' do
      login_for_request(user)
      get question_problem_path(problem)
      patch answer_problem_path(problem), params: { problem: { answer: 0 } }
      patch answer_problem_path(problem), params: { problem: { answer: 0 } }
      get answer_problem_path(problem)
      expect(response).to redirect_to root_path
    end
  end
end
