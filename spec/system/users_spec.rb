require 'rails_helper'

def basic_pass(path) # basic認証
  username = ENV['FURIMA_BASIC_AUTH_USER']
  password = ENV['FURIMA_BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end


RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do 
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      basic_pass root_path
      
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      
      # 新規登録ページへ移動する
      visit new_user_registration_path

      # ユーザー情報を入力する
      fill_in 'ニックネーム', with: @user.nickname
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード', with: @user.password
      fill_in 'パスワード(確認)', with: @user.password_confirmation
      fill_in 'first-name', with: @user.first_name
      fill_in 'last-name', with: @user.last_name
      fill_in 'first-name-kana', with: @user.first_name_kana
      fill_in 'last-name-kana', with: @user.last_name_kana
      select @user.birth_date.strftime("%Y"), from: 'user_birth_date_1i' # 生"年"月日
      select @user.birth_date.strftime("%-m"), from: 'user_birth_date_2i' # 生年"月"日(0を抜いて左寄せ)
      select @user.birth_date.strftime("%-d"), from: 'user_birth_date_3i' # 生年月"日"(0を抜いて左寄せ)

      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(1)
      
      # トップページへ遷移したことを確認する
      expect(current_path).to eq root_path
      
      # ログアウトボタンが表示されていることを確認する
      expect(page).to have_content('ログアウト')
      
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      # 新規登録ページへ移動する
      # ユーザー情報を入力する
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      # 新規登録ページへ戻されることを確認する
    end
  end
end

