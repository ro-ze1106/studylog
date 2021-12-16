require 'rails_helper'

RSpec.describe "お気に入り登録機能", type: :request do
  let!(:user) { create(:user) }
  let!(:problem) {create(:problem) }

  context 'お気に入り登録機能' do
    context 'ログインしている場合' do
      before do
        login_for_request(user)
      end

      it '問題がお気に入りに登録できること' do
        expect {
          post "/favorites/#{problem.id}/create"
      }.to change(user.favorites, :count).by(1)
      end

      it '問題のAjaxによるお気に入り登録ができること' do
        expect {
          post "/favorites/#{problem.id}/create", xhr: true
        }.to change(user.favorites, :count).by(1)
        end

        it '問題のお気に入り解除ができること' do
          user.favorite(problem)
          expect {
            delete "/favorites/#{problem.id}/destroy"
          }.to change(user.favorites, :count).by(-1)
        end

        it '問題のAjaxによるお気に入り解除ができること' do
          user.favorite(problem)
          expect {
            delete "/favorites/#{problem.id}/destroy", xhr: true
          }.to change(user.favorites, :count).by(-1)
        end
      end

    context 'ログインしていない場合' do
      it 'お気に入り登録は実行できず、ログインページへリダイレクトすること' do
        expect {
          post "/favorites/#{problem.id}/create"
      }.not_to change(Favorite, :count)
      expect(response).to redirect_to login_path
      end

      it 'お気に入り解除は実行できず、ログインページへリダイレクトすること' do
        expect {
          delete "/favorites/#{problem.id}/destroy"
        }.not_to change(Favorite, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
end
