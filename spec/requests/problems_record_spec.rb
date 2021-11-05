require 'rails_helper'

RSpec.describe "問題登録", type: :request do
  let!(:user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }

  context 'ログインしているユーザーの場合' do
    it 'レスポンスが正常に表示されてこと' do
      login_for_request(user)
      get new_problem_path
      expect(response).to have_http_status '200'
      expect(response).to render_template('problems/new')
    end
  end

  context 'ログインしていないユーザーの場合' do
    it 'ログイン画面にリダイレクトされること' do
      get new_problem_path
      expect(response).to have_http_status '302'
      expect(response).to redirect_to login_path
    end
  end
end
