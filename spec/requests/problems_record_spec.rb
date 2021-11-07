require 'rails_helper'

RSpec.describe "問題登録", type: :request do
  let!(:user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }

  context 'ログインしているユーザーの場合' do
    before do
      login_for_request(user)
      get new_problem_path
    end

    it 'レスポンスが正常に表示されてこと' do
      expect(response).to have_http_status '200'
      expect(response).to render_template('problems/new')
    end

    it '有効な問題データが作成されること' do
      expect {
        post problems_path, params: { problem: { study_type: '理科',
                                                 title: '元素記号',
                                                 explanation_text: '元素記号を答えなさい',
                                                 problem_text: 'H',
                                                 answer: '水素',
                                                 problem_explanation: '元素記号表を覚えよう',
                                                 target_age: '13',
                                                 reference: 'https://www.gadgety.net/shin/trivia/ptable/'
        } }
      }.to change(Problem, :count).by(1)
      follow_redirect!
      expect(response).to render_template('problems/show')
    end

    it '無効な問題データでは作成されないこと' do
      expect {
        post problems_path, params: { problem: { study_type: '',
                                      title: '元素記号',
                                      explanation_text: '元素記号を答えなさい',
                                      problem_text: '',
                                      answer: '',
                                      problem_explanation: '元素記号表を覚えよう',
                                      target_age: '13',
                                      reference: 'https://www.gadgety.net/shin/trivia/ptable/'
        } } 
      }.not_to change(Problem, :count)
      expect(response).to render_template('problems/new')
    end
  end

  context 'ログインしていないユーザーの場合' do
    it 'ログイン画面にリダイレクトされること' do
      get new_problem_path
      expect(response).to have_http_status '302'
      expect(response).to redirect_to login_path
    end
  end
end
# :study_type, :title, :explanation_text, :problem_text, :answer, :problem_explanation, :taget_age, :reference