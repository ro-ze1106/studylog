require 'rails_helper'

RSpec.describe '問題個別ページ', type: :request do
  let!(:user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }

  context '認可されたユーザーの場合' do
    it 'レスポンスが正常に表示されること' do
      login_for_request(user)
      get problem_path(problem)
      expect(response).to have_http_status '200'
      expect(response).to render_template('problems/show')
    end
  end

  context 'ログインしていないユーザーの場合' do
    it 'ログイン画面にリダイレクトされること' do
      get problem_path(problem)
      expect(response).to have_http_status '302'
      expect(response).to redirect_to login_path
    end
  end
end
