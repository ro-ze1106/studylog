require 'rails_helper'

RSpec.describe '通知機能', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }
  let!(:other_problem) { create(:problem, user: other_user) }

  context '通知一覧ページの表示' do
    context 'ログインしているユーザーの場合' do
      before do
        login_for_request(user)
      end

      it 'レスポンスが正常に表示されること' do
        get notifications_path
        expect(response).to have_http_status '200'
      end
    end

    context 'ログインしていないユーザーの場合' do
      it 'ログインページにリダイレクトされること' do
        get notifications_path
        expect(response).to have_http_status '302'
        expect(response).to redirect_to login_path
      end
    end
  end

  context '通知機能' do
    before do
      login_for_request(user)
    end

    context '自分の問題に対して' do
      it 'お気に入り登録によって通知が作成されないこと' do
        post "/favorites/#{problem.id}/create"
        expect(user.reload.notification).to be_falsey
      end

      it 'コメントによって通知が作成されないこと' do
        post comments_path, params: { problem_id: problem.id,
                                      comment: {
                                        content: '簡単!'
                                      } }
        expect(user.reload.notification).to be_falsey
      end
    end

    context '自分以外のユーザーの問題に対して' do
      it 'お気に入り登録によって通知が作成されること' do
        post "/favorites/#{other_problem.id}/create"
        expect(user.reload.notification).to be_falsey
        expect(other_user.reload.notification).to be_truthy
      end

      it 'コメントによって通知が作成されること' do
        post comments_path, params: { problem_id: other_problem.id,
                                      comment: { content: '簡単!' } }
        expect(user.reload.notification).to be_falsey
        expect(other_user.reload.notification).to be_truthy
      end
    end
  end
end
