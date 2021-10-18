require 'rails_helper'

RSpec.describe 'users_index', type: :system do
  let!(:user) { create (:user) }

  describe 'ユーザー一覧ページ' do
    it 'ページネーション、最初のページにユーザーが存在すること' do
      create_list(:user, 31)
      login_for_system(user)
      visit users_path
      expect(page).to have_css 'div.pagination'
      User.paginate(page: 1 ).each do |u|
        expect(page).to have_link u.name, href: user_path(u)
      end
    end
  end
end
