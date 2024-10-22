require 'rails_helper'

RSpec.describe MaterialEvaluation, type: :model do
  before do
    @material_evaluation = FactoryBot.build(:material_evaluation)
  end
  describe '教材評価新規登録' do
    context '新規登録失敗パターン' do
      it 'evaluationがない場合にバリデーションが機能する' do
        @material_evaluation.evaluation = ''
        @material_evaluation.valid?
        expect(@material_evaluation.errors.full_messages).to include('教材評価を入力してください')
      end
      
      it 'bodyがない場合にバリデーションが機能する' do
        @material_evaluation.body = ''
        @material_evaluation.valid?
        expect(@material_evaluation.errors.full_messages).to include('教材評価コメントを入力してください')
      end

      it 'bodyが501文字以上の場合にバリデーションが機能する' do
        @material_evaluation.body = 'a' * 501
        @material_evaluation.valid?
        expect(@material_evaluation.errors.full_messages).to include('教材評価コメントは500文字以内で入力してください')
      end
    end
    context '教材評価新規登録成功パターン' do
      it '内容に問題ない場合' do
        expect(@material_evaluation).to be_valid
      end
    end
  end
end
