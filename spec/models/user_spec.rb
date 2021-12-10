require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  context 'バリデーション' do
    it '名前とメールアドレスがあれば有効な状態であること' do
      expect(user).to be_valid
    end

    it '名前がなければ無効の状態であること' do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include
    end

    it 'Eメールアドレスがなければ無効の状態であること' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include
    end

    it '名前が50文字以内であること' do
      user = build(:user, name: 'a' * 51)
      user.valid?
      expect(user.errors[:name]).to include
    end

    it 'Eメールアドレスが255文字以内であること' do
      user = build(:user, email: "#{'a' * 244}@example.com")
      user.valid?
      expect(user.errors[:email]).to include
    end

    it '重複するメールアドレスを無効な状態であること' do
      other_user = build(:user, email: user.email)
      other_user.valid?
      expect(other_user.errors[:email]).to include
    end

    it 'Eメールアドレスは小文字で登録されること' do
      email = 'ExamPle@example.com'
      user = create(:user, email: email)
      expect(user.email).to eq email.downcase
    end

    it 'パスワードがなければ無効な状態であること' do
    user = build(:user, password: nil, password_confirmation: nil)
    user.valid?
    expect(user.errors[:password]).to include
    end

    it 'パスワードが6文字以上であること' do
    user = build(:user, password: 'a' * 6, password_confirmation: 'a' * 6)
    user.valid?
    expect(user).to be_valid
    end
  end

  context 'authenticated?メソッド' do
    it 'ダイジェストが存在しない場合、falseを返すこと' do
      expect(user.authenticated?('')).to eq false
    end
  end

  context "フォロー機能" do
    it 'フォローからフォロー解除までの動作確認' do
      expect(user.following?(other_user)).to be_falsey
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
      expect(other_user.followed_by?(user)).to be_truthy
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be_falsey
    end
  end
end
