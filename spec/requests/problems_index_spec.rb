require 'rails_helper'

RSpec.describe '問題一覧ページ', type: :request do
  let!(:user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }

  context 'ログインしているユーザーの場合' do
    it 'レスポンスが正常に表示されること' do
      login_for_request(user)
      get problems_path
      expect(response).to have_http_status '200'
      expect(response).to render_template('problems/index')
    end
  end

  context 'ログインしていないユーザーの場合' do
    it '採用担当者ログイン画面にリダイレクトされること' do
      get problems_path
      expect(response).to have_http_status '302'
      expect(response).to redirect_to recruit_login_path
    end
  end
end
