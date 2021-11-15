require 'rails_helper'

RSpec.describe '問題の削除', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }

  context 'ログインしていて、自分の問題を削除する場合' do
    it '処理が成功し、トップページにリダイレクトすること' do
      login_for_request(user)
      expect {
        delete problem_path(problem)
      }.to change(Problem, :count).by(-1)
    redirect_to user_path(user)
    follow_redirect!
    expect(response).to render_template('static_pages/home')
    end
  end

  context 'ログインしていて、他人の問題を削除する場合' do
    it '処理が失敗し、トップページにリダイレクトすること' do
      login_for_request(other_user)
      expect {
        delete problem_path(problem)
      }.not_to change(Problem, :count)
      expect(response).to have_http_status '302'
      expect(response).to redirect_to root_path
    end
  end

  context 'ログインしていない場合' do
    it 'ログインページにリダイレクトされること' do
      expect {
        delete problem_path(problem)
      }.not_to change(Problem, :count)
      expect(response).to have_http_status '302'
      expect(response).to redirect_to login_path
    end
  end
end
