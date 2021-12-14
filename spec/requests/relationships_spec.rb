require 'rails_helper'

RSpec.describe 'ユーザーフォロー機能', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  context 'ログインしている場合' do
    before do
      login_for_request(user)
    end

    it 'ユーザーがフォローできること' do
      expect {
        post relationships_path, params: { followed_id: other_user.id }
      }.to change(user.following, :count).by(1)
    end

    it 'ユーザーのAjaxによるフォローができること' do
      expect {
        post relationships_path, xhr: true, params: { followed_id: other_user.id }
      }.to change(user.following, :count).by(1)
    end

    it 'ユーザーがアンフォローできること' do
      user.follow(other_user)
      relationship = user.active_relationships.find_by(followed_id: other_user.id)
      expect {
        delete relationship_path(relationship)
      }.to change(user.following, :count).by(-1)
    end

    it 'ユーザーのAjaxによるアンフォローができること' do
      user.follow(other_user)
      relationship = user.active_relationships.find_by(followed_id: other_user.id)
      expect {
        delete relationship_path(relationship), xhr: true
      }.to change(user.following, :count).by(-1)
    end
  end

  context 'ログインしていない場合' do
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

    it 'createアクションは実行できず、ログインページにリダイレクトすること' do
      expect {
        post relationships_path
      }.not_to change(Relationship, :count)
    expect(response).to redirect_to login_path
    end

    it 'destroyアクションは実行できず、ログインページにリダイレクトすること' do
      expect {
        delete relationship_path(user)
      }.not_to change(Relationship, :count)
    expect(response).to redirect_to login_path
    end
  end
end
