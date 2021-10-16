require 'rails_helper'

RSpec.describe 'プロフィール編集', type: :request do
  let!(:user) { create (:user) }

  before do
    get edit_user_path(user)
  end

  it '無効なプロフィール編集' do
    expect(response).to render_template('users/edit')
    patch user_path(user), params: {user: { name:"",
    email: "test@example",
    password: "tes",
    password_confirmation: "test"
    }}
    expect(response).to render_template('users/edit')
  end

  it '有効なプロフィール編集' do
    expect(response).to render_template('users/edit')
    patch user_path(user), params: {user: { name: "name",
    email: "test@example.com",
    password: "",
    password_confirmation: ""
    }}
    redirect_to user
    follow_redirect!
    expect(response).to render_template('users/show')
  end

end