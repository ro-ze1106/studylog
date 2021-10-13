require 'rails_helper'

RSpec.describe 'ログイン', type: :request do
  let!(:user) { create(:user) }

  it '正常なレスポンスを返すこと' do
    get login_path
    expect(response).to be_successful
    expect(response).to have_http_status '200'
  end

  it '有効なユーザーでログイン＆ログアウト' do
    get login_path
    post login_path, params: { session: { email: user.email,
                                          password: user.password } }
    redirect_to user
    follow_redirect!
    expect(response).to render_template('users/show')
    expect(is_logged_in?).to be_truthy
    delete logout_path
    expect(is_logged_in?).not_to be_truthy
    redirect_to root_url
    delete logout_path
    follow_redirect!
  end

  it '無効なユーザーでログイン' do
    get login_path
    post login_path, params: { session: { email: '111@',
                                          password: user.password } }
    expect(is_logged_in?).not_to be_truthy
  end

  it "「ログインしたままにする」にチェックしてログイン" do
    post login_path, params: { session: { email: user.email,
                                          password: user.password,
                                          remember_me: '1' } }
    expect(response.cookies['remember_token']).not_to eq nil
  end

  it "「ログインしたままにする」にチェックせずにログイン" do
    # クッキーを保存してログイン
    post login_path, params: { session: { email: user.email,
                                          password: user.password,
                                          remember_me: '1' } }
    delete logout_path
    # クッキーを保存せずにログイン
    post login_path, params: { session: { email: user.email,
                                          password: user.password,
                                          remember_me: '0' } }
    expect(response.cookies['remember_token']).to eq nil
  end
end
