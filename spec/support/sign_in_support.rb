module SignInSupport
  def sign_in(user)
    visit new_user_session_path 
    fill_in '名前', with: user.name
    fill_in '拠点', with: user.base
    fill_in '担当商材', with: user.base_sub
    fill_in 'Password', with: user.password 
    fill_in 'メールアドレス', with: :user.email
    fill_in 'パスワード', with: :user.password
    fill_in 'パスワード確認', with: :user.password_confirmation
    find('input[name="commit"]').click 
    expect(current_path).to eq(root_path)
  end 
end