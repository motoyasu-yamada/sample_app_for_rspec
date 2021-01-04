module LoginMacros
  def login(user)
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: '12345678'
    click_button 'Login'
  end
end
