require 'rails_helper'

RSpec.describe "ユーザーフォロー機能", type: :request do
  let(:user) { create(:user) }

  context "ログインしていない場合" do
    it 'followingページへ飛ぶとログインページにリダイレクトされること' do
      get following_user_path(user)
      expect(response).to have_http_status '302'
      expect(response).to redirect_to login_path
    end

    it 'followersページへ飛ぶとログインページにリダイレクトされること' do
      get followers_user_path(user)
      expect(response).to have_http_status '302'
      expect(response).to redirect_to login_path
    end
  end
end
