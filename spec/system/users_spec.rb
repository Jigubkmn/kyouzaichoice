require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe 'ユーザー新規登録' do
    context 'フォーム入力値が正常' do
      it 'ユーザー新規登録が成功する' do
        visit new_user_path
        fill_in 'ユーザー名', with: 'テストユーザー'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button '登録'
        expect(page).to have_content 'ユーザー登録が完了しました'
        expect(current_path).to eq materials_path
      end
    end
    
    context 'ユーザー名が未入力' do
      it 'ユーザー新規登録が失敗する' do
        visit new_user_path
        fill_in 'ユーザー名', with: ''
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button '登録'
        expect(page).to have_content 'ユーザー登録に失敗しました'
        expect(page).to have_content 'ユーザー名を入力してください'
        expect(current_path).to eq new_user_path
      end
    end

    context 'メールアドレスが未入力' do
      it 'ユーザー新規登録が失敗する' do
        visit new_user_path
        fill_in 'ユーザー名', with: user.name
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button '登録'
        expect(page).to have_content 'ユーザー登録に失敗しました'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(current_path).to eq new_user_path
      end
    end

    context 'パスワードが未入力' do
      it 'ユーザー新規登録が失敗する' do
        visit new_user_path
        fill_in 'ユーザー名', with: user.name
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: ''
        fill_in 'パスワード確認', with: 'password'
        click_button '登録'
        expect(page).to have_content 'ユーザー登録に失敗しました'
        expect(page).to have_content 'パスワードを入力してください'
        expect(page).to have_content 'パスワードは4文字以上で入力してください'
        expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
        expect(current_path).to eq new_user_path
      end
    end

    context 'パスワード確認が未入力' do
      it 'ユーザー新規登録が失敗する' do
        visit new_user_path
        fill_in 'ユーザー名', with: user.name
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: ''
        click_button '登録'
        expect(page).to have_content 'ユーザー登録に失敗しました'
        expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
        expect(page).to have_content 'パスワード確認を入力してください'
        expect(current_path).to eq new_user_path
      end
    end
  end

  describe 'ログインページに遷移' do
    it '遷移リンクをクリック' do
      visit new_user_path
      click_link 'ログインページはこちら'
    end
  end
end

