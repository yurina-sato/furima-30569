module SignInSupport
  def basic_pass(path) # basic認証
    username = ENV['FURIMA_BASIC_AUTH_USER']
    password = ENV['FURIMA_BASIC_AUTH_PASSWORD']
    visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
  end
  
  def sign_in(user) # ログイン
    basic_pass new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path
  end
end