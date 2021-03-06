require 'rails_helper'

RSpec.describe 'Problems', type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:problem) { create(:problem, :picture, user: user) }
  let!(:comment) { create(:comment, user_id: user.id, problem: problem) }

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
        expect(page).to have_title full_title('問題作成')
      end

      it '入力部分に適切なラベルが表示されていること' do
        expect(page).to have_content '教科'
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
        fill_in '教科', with: '算数'
        fill_in 'タイトル名', with: '計算問題'
        fill_in '説明文', with: '計算しなさい'
        fill_in '問題文', with: '1＋1'
        fill_in '答え', with: '2'
        fill_in '問題解説', with: '僕と友達がいました。合わせていくつ？'
        fill_in '対象年齢', with: '7'
        fill_in '参考用URL', with: 'https://hugkum.sho.jp/48150'
        attach_file 'problem[picture]', "#{Rails.root}/spec/fixtures/test_problem2.png"
        click_button '作成する'
        expect(page).to have_content '問題が作成されました！'
      end

      it '無効な情報で問題作成を行うと問題作成失敗のフラッシュが表示されること' do
        fill_in '教科', with: '算数'
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

  describe '問題詳細ページ' do
    context 'ページレイアウト' do
      before do
        login_for_system(user)
        visit problem_path(problem)
      end

      it '正しいタイトルが表示されていること' do
        expect(page).to have_title full_title(problem.title.to_s)
      end

      it '問題(problem)情報が表示されること' do
        expect(page).to have_content problem.title
        expect(page).to have_content problem.study_type
        expect(page).to have_content problem.explanation_text
        expect(page).to have_content problem.problem_text
        expect(page).to have_content problem.answer
        expect(page).to have_content problem.problem_explanation
        expect(page).to have_content problem.target_age
        expect(page).to have_content problem.reference
      end
    end

    context '問題の削除', js: true do
      it '削除成功のフラッシュが表示されること' do
        login_for_system(user)
        visit problem_path(problem)
        within find('.change-problem') do
          click_on '削除'
        end
        expect {
          expect(page.accept_confirm).to eq '本当に削除しますか？'
          expect(page).to have_content '問題が削除されました'
        }
      end
    end
  end

  describe '問題編集ページ' do
    before do
      login_for_system(user)
      visit problem_path(problem)
      click_link '編集'
    end

    context 'レイアウトページ' do
      it '正しいタイトルが表示されていること' do
        expect(page).to have_title full_title('問題情報の編集')
      end

      it '入力部分に適切なラベルが表座されること' do
        expect(page).to have_content '教科'
        expect(page).to have_content 'タイトル名'
        expect(page).to have_content '説明文'
        expect(page).to have_content '問題文'
        expect(page).to have_content '答え'
        expect(page).to have_content '問題解説'
        expect(page).to have_content '対象年齢'
        expect(page).to have_content '参考用URL'
      end

      it '画像アップロード部分が表示されること' do
        expect(page).to have_css 'input[type=file]'
      end
    end

    context '問題の更新処理' do
      it '有効な更新' do
        fill_in '教科', with: '更新:算数'
        fill_in 'タイトル名', with: '更新:計算問題'
        fill_in '説明文', with: '更新:計算しなさい'
        fill_in '問題文', with: '更新:12×7＝'
        fill_in '答え', with: '更新:84'
        fill_in '問題解説', with: '更新:人が1グループ12人いました。7グループだと何人ですか？'
        fill_in '対象年齢', with: '12'
        fill_in '参考用URL', with: 'hensyu-https://www.dainippon-tosho.co.jp/mext/e07.html'
        attach_file 'problem[picture]', "#{Rails.root}/spec/fixtures/test_problem2.png"
        click_button '更新する'
        expect(page).to have_content '問題情報が更新されました！'
        expect(problem.reload.study_type).to eq '更新:算数'
        expect(problem.reload.title).to eq '更新:計算問題'
        expect(problem.reload.explanation_text).to eq '更新:計算しなさい'
        expect(problem.reload.problem_text).to eq '更新:12×7＝'
        expect(problem.reload.answer).to eq '更新:84'
        expect(problem.reload.problem_explanation).to eq '更新:人が1グループ12人いました。7グループだと何人ですか？'
        expect(problem.reload.target_age).to eq '12'
        expect(problem.reload.reference).to eq 'hensyu-https://www.dainippon-tosho.co.jp/mext/e07.html'
        expect(problem.reload.picture.filename.to_s).to eq 'test_problem2.png'
      end

      it '無効な更新' do
        fill_in 'タイトル名', with: ''
        click_button '更新する'
        expect(page).to have_content 'タイトル名を入力してください'
        expect(problem.reload.title).not_to eq ''
      end

      context '問題の削除処理', js: true do
        it '削除成功のフラッシュが表示されること' do
          click_on '削除'
          expect {
            expect(page.accept_confirm).to eq '本当に削除しますか？'
            expect(page).to have_content '問題が削除されました'
          }
        end
      end
    end
  end

  context 'コメントの登録と削除' do
    it '自分に対するコメントの登録と削除が正常に完了すること' do
      login_for_system(user)
      visit problem_path(problem)
      fill_in 'comment_content', with: '難しいですね'
      click_button 'コメント'
      within find("#comment-#{Comment.last.id}") do
        expect(page).to have_selector 'span', text: user.name
        expect(page).to have_selector 'span', text: '難しいですね'
      end
      expect(page).to have_content 'コメントを追加しました!'
      click_link '削除', href: comment_path(Comment.last)
      expect(page).not_to have_selector 'span', text: '難しいですね'
      expect(page).to have_content 'コメントを削除しました'
    end

    it '別のユーザーのコメントには削除リンクがないこと' do
      login_for_system(other_user)
      visit problem_path(problem)
      within find("#comment-#{comment.id}") do
        expect(page).to have_selector 'span', text: user.name
        expect(page).to have_selector 'span', text: comment.content
        expect(page).not_to have_link '削除', href: problem_path(problem)
      end
    end
  end
end
