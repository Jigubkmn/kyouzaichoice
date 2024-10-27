require 'rails_helper'

RSpec.describe "Qualifications", type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user)
    visit profile_user_path
  end

  describe '資格を登録' do
    context 'フォーム入力値が正常な場合' do
      it '資格の登録が成功する' do
        visit new_qualification_path
        fill_in '資格名', with: '資格名'
        select '学習中', from: 'progress-select'
        click_button '登録'
        expect(page).to have_content '資格を登録しました'
        expect(current_path).to eq qualifications_path
      end
    end

    context '資格名が未入力' do
      it '資格の登録が失敗する' do
        visit new_qualification_path
        fill_in '資格名', with: ''
        select '学習中', from: 'progress-select'
        click_button '登録'
        expect(page).to have_content '資格を登録出来ませんでした'
        expect(page).to have_content '資格名を入力してください'
        expect(current_path).to eq new_qualification_path
      end
    end

    context '進捗状況が未入力' do
      it '資格の登録が失敗する' do
        visit new_qualification_path
        fill_in '資格名', with: '資格名'
        select '', from: 'progress-select'
        click_button '登録'
        expect(page).to have_content '資格を登録出来ませんでした'
        expect(page).to have_content '進捗状況を入力してください'
        expect(current_path).to eq new_qualification_path
      end
    end
  end

  describe '資格を更新' do
    let!(:qualification) { create(:qualification, user: user) }
    context 'フォーム入力値が正常な場合' do
      it '資格の更新が成功する' do
        visit edit_qualification_path(qualification)
        fill_in '資格名', with: '資格名'
        select '学習中', from: 'progress-select'
        click_button '更新'
        expect(page).to have_content '資格を更新しました'
        expect(current_path).to eq qualifications_path
      end
    end

    context '資格名が未入力' do
      it '資格の更新が失敗する' do
        visit edit_qualification_path(qualification)
        fill_in '資格名', with: ''
        select '学習中', from: 'progress-select'
        click_button '更新'
        expect(page).to have_content '資格を更新出来ませんでした'
        expect(page).to have_content '資格名を入力してください'
        expect(current_path).to eq edit_qualification_path(qualification)
      end
    end

    context '進捗状況が未入力' do
      it '資格の更新が失敗する' do
        visit edit_qualification_path(qualification)
        fill_in '資格名', with: '資格名'
        select '', from: 'progress-select'
        click_button '更新'
        expect(page).to have_content '資格を更新出来ませんでした'
        expect(page).to have_content '進捗状況を入力してください'
        expect(current_path).to eq edit_qualification_path(qualification)
      end
    end
  end

  describe '資格を削除' do
    let!(:qualification) { create(:qualification, user: user) }
    it '資格の削除に成功する' do
      visit qualifications_path
      # 資格名がページに表示されていることを確認
      expect(page).to have_content qualification.name
      
      # 削除リンク（ゴミ箱アイコン）をクリック
      find("a[href='#{qualification_path(qualification)}'][data-turbo-method='delete']").click
      expect(page).to have_content '資格を削除しました'
      expect(current_path).to eq qualifications_path
    end
  end
end
