require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /new' do
    it 'returns http success' do
      get '/users/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'ユーザー登録' do
    it '正常なレスポンスを返す事' do
      get signup_path
      expect(response).to be_successful
      expect(response).to have_http_status '200'
    end
  end
end
