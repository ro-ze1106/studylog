require 'rails_helper'

RSpec.describe 'ユーザー削除', type: :request do

  let!(:user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }

  context '問題が紐づくユーザーを削除した場合' do
    it '問題がユーザーと一緒に削除されること' do
      login_for_request(user)
      expect {
        delete user_path(user)
      }.to change(Problem, :count).by(-1)
    end
  end
end