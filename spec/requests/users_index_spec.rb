require 'rails_helper'

RSpec.describe 'ユーザー一覧', type: :request do
  let!(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }

  context '認可されたユーザーの場合' do
    it 'レスポンスが正常に表示されること' do
      login_for_request(user)
      get users_path
      expect(response).to have_http_status '200'
      expect(response).to render_template('users/index')
    end
  end

  context 'ログインされていないユーザーの場合' do
    it '採用担当者ログインページにリダイレクトすること' do
      get users_path
      expect(response).to have_http_status '302'
      expect(response).to redirect_to recruit_login_path
    end

    it 'admin属性の変更が禁止されていること' do
      login_for_request(user)
      expect(user.admin).to be_falsey
      patch user_path(user), params: { user: { password: user.password,
                                               password_confirmation: user.password,
                                               admin: true } }
      expect(user.reload.admin).to be_falsey
    end
  end
end
