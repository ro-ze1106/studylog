require 'rails_helper'

RSpec.describe "問題編集", type: :request do
  let!(:user) { create(:user)}
  let!(:problem) { create(:problem, user: user)}

  context "認可されたユーザーの場合" do
    it 'レスポンスが正常に表示されること(+フレンドリーフォワーディング)' do
      get edit_problem_path(problem)
      login_for_request(user)
      expect(response).to redirect_to edit_problem_url(problem)
      patch problem_path(problem), params: { problem: { study_type: '理科',
                                                        title: '元素記号',
                                                        explanation_text: '元素記号を答えなさい',
                                                        problem_text: 'H',
                                                        answer: '水素',} }
      redirect_to problem
      follow_redirect!
      expect(response).to render_template('problems/show')
    end
  end

  context 'ログインしていないユーザーの場合' do
    it 'ログインページにリダイレクトされる' do
      # 編集
      get edit_problem_path(problem)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
      # 更新
      patch problem_path(problem), params: { problem: { study_type: '理科',
                                                        title: '元素記号',
                                                        explanation_text: '元素記号を答えなさい',
                                                        problem_text: 'H',
                                                        answer: '水素',} }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
