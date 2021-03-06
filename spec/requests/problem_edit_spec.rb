require 'rails_helper'

RSpec.describe '問題編集', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }
  let(:picture2_path) { File.join(Rails.root, 'spec/fixtures/test_problem2.png') }
  let(:picture2) { Rack::Test::UploadedFile.new(picture2_path) }

  context '認可されたユーザーの場合' do
    it 'レスポンスが正常に表示されること(+フレンドリーフォワーディング)' do
      get edit_problem_path(problem)
      login_for_request(user)
      expect(response).to redirect_to edit_problem_url(problem)
      patch problem_path(problem), params: { problem: { study_type: '理科',
                                                        title: '元素記号',
                                                        explanation_text: '元素記号を答えなさい',
                                                        problem_text: 'H',
                                                        answer: '水素',
                                                        picture: picture2 } }
      redirect_to problem
      follow_redirect!
      expect(response).to render_template('problems/show')
    end
  end

  context 'ログインしていないユーザーの場合' do
    it '採用担当者ログインページにリダイレクトされる' do
      # 編集
      get edit_problem_path(problem)
      expect(response).to have_http_status '302'
      expect(response).to redirect_to recruit_login_path
      # 更新
      patch problem_path(problem), params: { problem: { study_type: '理科',
                                                        title: '元素記号',
                                                        explanation_text: '元素記号を答えなさい',
                                                        problem_text: 'H',
                                                        answer: '水素', } }
      expect(response).to have_http_status '302'
      expect(response).to redirect_to recruit_login_path
    end
  end

  context '別アカウントのユーザーの場合' do
    it 'ホーム画面にリダイレクトされること' do
      # 編集
      login_for_request(other_user)
      get edit_problem_path(problem)
      expect(response).to have_http_status '302'
      expect(response).to redirect_to root_path
      # 更新
      patch problem_path(problem), params: { problem: { study_type: '理科',
                                                        title: '元素記号',
                                                        explanation_text: '元素記号を答えなさい',
                                                        problem_text: 'H',
                                                        answer: '水素', } }
      expect(response).to have_http_status '302'
      expect(response).to redirect_to root_path
    end
  end
end
