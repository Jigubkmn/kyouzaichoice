require 'rails_helper'

RSpec.describe "Materials", type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user)
    visit already_registered_materials_path
  end

  # 共通の検索処理
  def search_material(query)
    click_link '教材を登録'
    expect(page).to have_current_path(search_materials_path)
    fill_in 'search', with: query
    click_button '検索'
    expect(page).to have_content 'プロを目指す人のためのRuby入門'
  end

  describe '教材を登録' do
    context 'フォーム入力値が正常' do
      it '教材検索が成功する' do
        expect(page).to have_current_path(already_registered_materials_path)
        search_material('プロを目指す人のためのRuby入門')
      end

      it '教材登録が成功する' do
        expect(page).to have_current_path(already_registered_materials_path)
        search_material('プロを目指す人のためのRuby入門')
        click_button 'select-button-0'
        check '初学者'
        check '1冊で合格'
        check '問題数多め'
        select '3.0', from: '教材評価'
        click_button '登録'
      end
    end
  end
end