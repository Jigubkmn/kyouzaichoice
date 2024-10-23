require 'rails_helper'
require 'spec_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'ユーザー新規登録' do
        it 'フォーム入力値が正常' do
          visit new_user_path
          fill_in 'email', with: user.email
          fill_in 'password', with: user.password
          fill_in 'password_confirmation', with: user.password_confirmation
          click_button '登録'
          expect(page).to have_content 'ユーザー登録が完了しました'
          expect(current_path).to eq materials_path
        end
      end
    end
  end
end

