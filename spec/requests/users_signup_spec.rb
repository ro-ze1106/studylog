require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :request do
  before do
    get signup_path
  end

  it '正常なレスポンスを返す事' do
    expect(response).to be_successful
    expect(response).to have_http_status '200'
  end

  it "無効なユーザーで登録" do
    expect {
      post users_path, params: { user: { name: "",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "pass" } }
    }.not_to change(User, :count)
  end

  it "有効なユーザーで登録" do
    expect {
      post users_path, params: { user: { name: "User",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password"}}
  }.to change(User, :count).by(1)
  redirect_to @user
  end
end