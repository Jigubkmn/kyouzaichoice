module LoginMacros
  def login_as(user)
    # root_pathに対してパスする
    visit root_path
    # 'Login'をクリック
    click_link 'Login'
    # Emailフォームに　user_nameを入れる
    fill_in 'Email', with: user.email
    # Passwordフォームに　passwordを入れる
    fill_in 'Password', with: 'password'
    # 'Login'をクリック
    click_button 'Login'
  end
end