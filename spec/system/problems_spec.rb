require 'rails_helper'

RSpec.describe "Problems", type: :system do
  let!(:user) { create(:user) }

  describe '問題作成ページ' do
    before do
      login_for_system(user)
      visit new_problem_path
    end

    context 'ページレイアウト' do
      it '「問題作成」の文字列が存在すること' do
        expect(page).to have_content '問題作成'
      end

      it '正しいタイトルが表示されていること' do
        expect(page).to have_title full_title ('問題作成')
      end

      it '入力部分に適切なラベルが表示されていること' do
        expect(page).to have_content '科目'
        expect(page).to have_content 'タイトル名'
        expect(page).to have_content '説明文'
        expect(page).to have_content '問題文'
        expect(page).to have_content '答え'
        expect(page).to have_content '問題解説'
        expect(page).to have_content '対象年齢'
        expect(page).to have_content '参考用URL'
      end
    end

    context '問題作成処理' do
      it '有効な情報で問題作成を行うと問題作成成功のフラッシュが表示されること' do
        fill_in '科目', with: '算数'
        fill_in 'タイトル名', with: '計算問題'
        fill_in '説明文', with: '計算しなさい'
        fill_in '問題文', with: '1＋1'
        fill_in '答え', with: '2'
        fill_in '問題解説', with: '僕と友達がいました。合わせていくつ？'
        fill_in '対象年齢', with: '7'
        fill_in '参考用URL', with: 'https://hugkum.sho.jp/48150'
        click_button '作成する'
        expect(page).to have_content '問題が作成されました！'
      end

      it '無効な情報で問題作成を行うと問題作成失敗のフラッシュが表示されること' do
        fill_in '科目', with: '算数'
        fill_in 'タイトル名', with: '計算問題'
        fill_in '説明文', with: '計算しなさい'
        fill_in '問題文', with: ''
        fill_in '答え', with: '2'
        fill_in '問題解説', with: '僕と友達がいました。合わせていくつ？'
        fill_in '対象年齢', with: '7'
        fill_in '参考用URL', with: 'https://hugkum.sho.jp/48150'
        click_button '作成する'
        expect(page).to have_content '問題文を入力してください'
      end
    end
  end
end
