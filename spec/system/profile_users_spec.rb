require 'rails_helper'

RSpec.describe "ProfileUsers", type: :system do
  let(:user) { create(:user) }
  
  before do
    login_as(user)
    visit profile_user_path
  end

  describe 'プロフィール編集' do
    context 'フォーム入力値が正常な場合' do
      it 'プロフィール変更が成功する' do
        visit edit_profile_user_path
        fill_in 'ユーザー名', with: 'テストユーザー'
        fill_in 'メールアドレス', with: 'test@example.com'
        click_button '更新'
        expect(page).to have_content 'プロフィールを更新しました'
        expect(current_path).to eq profile_user_path
      end
    end

    context 'ユーザー名が未入力' do
      it 'プロフィール変更が失敗する' do
        visit edit_profile_user_path
        fill_in 'ユーザー名', with: ''
        fill_in 'メールアドレス', with: 'test@example.com'
        click_button '更新'
        expect(page).to have_content 'プロフィールを更新出来ませんでした'
        expect(page).to have_content 'ユーザー名を入力してください'
        expect(current_path).to eq edit_profile_user_path
      end
    end

    context 'メールアドレスが未入力' do
      it 'プロフィールが失敗する' do
        visit edit_profile_user_path
        fill_in 'ユーザー名', with: 'テストユーザー'
        fill_in 'メールアドレス', with: ''
        click_button '更新'
        expect(page).to have_content 'プロフィールを更新出来ませんでした'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(current_path).to eq edit_profile_user_path
      end
    end
  end
end