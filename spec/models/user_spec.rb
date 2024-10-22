require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end
  describe 'ユーザー新規登録' do
    context '新規登録失敗パターン' do
      it 'nameがない場合にバリデーションが機能する' do
        @user.name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('ユーザー名を入力してください')
      end

      it 'nameが101文字以上の場合にバリデーションが機能する' do
        @user.name = 'a' * 101
        @user.valid?
        expect(@user.errors.full_messages).to include('ユーザー名は100文字以内で入力してください')
      end

      it 'emailがない場合にバリデーションが機能する' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('メールアドレスを入力してください')
      end

      it '同じemailは登録ができない' do
        @user.save
        another_user = build(:user)
        another_user.email = @user.email
        another_user.valid?
      end

      it 'passwordがない場合にバリデーションが機能する' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードを入力してください')
      end

      it 'passwordが4文字以上でないとバリデーションが機能する' do
        @user.password = 'a' * 3
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは4文字以上で入力してください')
      end
      
      it '確認用のパスワードがない場合に、バリデーションが機能する' do
        @user.password_confirmation = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワード確認を入力してください')
      end
      
      it '確認用のパスワードは、入力されたパスワードと同じでないといけない。' do
        @user.password = 'password'
        @user.password_confirmation = '12345678'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワード確認とパスワードの入力が一致しません')
      end
    end

    context '新規登録成功パターン' do
      it '内容に問題ない場合' do
        expect(@user).to be_valid
      end
    end
  end
end