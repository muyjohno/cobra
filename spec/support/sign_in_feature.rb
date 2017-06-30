module SignInFeature
  def sign_in(user)
    visit new_user_session_path
    fill_in :user_email, with: user.email
    fill_in :user_password, with: 'test1234'
    click_button 'Log in'
  end
end
