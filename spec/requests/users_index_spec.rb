require 'rails_helper'

RSpec.describe 'ユーザー一覧', type: :request do
  let!(:user) {create (:user) }

  context '認可されたユーザーの場合' do
    it 'レスポンスが正常に表示されること' do
      login_for_request(user)
      get users_path
      expect(response).to have_http_status '200'
      expect(response).to render_template('users/index')
    end
  end

  context 'ログインされていないユーザーの場合' do
    it 'ログインページにリダイレクトすること' do
      get users_path
      expect(response).to have_http_status '302'
      expect(response).to redirect_to login_url
    end
  end
end