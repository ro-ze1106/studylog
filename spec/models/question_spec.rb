require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user) { create(:user) }
  let!(:problem) { create(:problem) }

  context 'バリデーション' do
    it '有効な状態であること' do
      expect(problem).to be_valid
    end
  end
end
