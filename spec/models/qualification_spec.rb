require 'rails_helper'

RSpec.describe Qualification, type: :model do
  before do
    @qualification = FactoryBot.build(:qualification)
  end
  describe '資格新規登録' do
    context '新規登録失敗パターン' do
      it 'nameがない場合にバリデーションが機能する' do
        @qualification.name = ''
        @qualification.valid?
        expect(@qualification.errors.full_messages).to include('資格名を入力してください')
      end

      it '同じnameは登録ができない' do
        @qualification.save
        another_qualification = build(:qualification)
        another_qualification.name = @qualification.name
        another_qualification.valid?
      end
      
      it 'progressがない場合にバリデーションが機能する' do
        @qualification.progress = ''
        @qualification.valid?
        expect(@qualification.errors.full_messages).to include('進捗状況を入力してください')
      end
    end
    context '資格新規登録成功パターン' do
      it '内容に問題ない場合' do
        expect(@qualification).to be_valid
      end
    end
  end
end
