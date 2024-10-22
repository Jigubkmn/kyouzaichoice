require 'rails_helper'

RSpec.describe Material, type: :model do
  before do
    @material = build(:material) 
  end
  describe '教材新規登録' do
    context '新規登録失敗パターン' do
      it 'titleがない場合にバリデーションが機能する' do
        @material.title = ''
        @material.valid?
        expect(@material.errors.full_messages).to include('Titleを入力してください')
      end
      
      it '同じtitleは登録ができない' do
        @material.save
        another_material = build(:material)
        another_material.title = @material.title
        another_material.valid?
      end


      it 'image_linkがない場合にバリデーションが機能する' do
        @material.image_link = ''
        @material.valid?
        expect(@material.errors.full_messages).to include('Image linkを入力してください')
      end

      it '同じimage_linkは登録ができない' do
        @material.save
        another_material = build(:material)
        another_material.image_link = @material.image_link
        another_material.valid?
      end
    end
    context '教材新規登録成功パターン' do
      it '内容に問題ない場合' do
        expect(@material).to be_valid
      end
    end
  end  
end
