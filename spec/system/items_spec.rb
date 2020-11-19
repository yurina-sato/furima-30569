require 'rails_helper'

def basic_pass(path) # basic認証
  username = ENV['FURIMA_BASIC_AUTH_USER']
  password = ENV['FURIMA_BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end


RSpec.describe '商品出品', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.build(:item)
  end
  context '商品出品ができるとき'do
    it 'ログインしたユーザーは商品出品ができる' do
      # ログインする
      basic_pass new_user_session_path
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 商品出品ページへのリンクがあることを確認する
      expect(page).to have_content('出品する')
      # 商品出品ページに移動する
      visit new_item_path
      # フォームに情報を入力する

      # 送信するとItemモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Item.count }.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq root_path
      # 「出品が完了しました」の文字があることを確認する
      expect(page).to have_content('出品が完了しました。')
      # トップページには先ほど出品した商品が存在することを確認する（画像）

      # トップページには先ほど出品した商品が存在することを確認する（商品名）
      expect(page).to have_content(@item.name)
      # トップページには先ほど出品した商品が存在することを確認する（価格）
      expect(page).to have_content(@item.price)
    end
  end
  context '商品出品ができないとき'do
    it 'ログインしていないと商品出品ページに遷移できない' do
      # トップページに遷移する
      # 商品出品ページへのリンクがあることを確認する
      # 商品出品ページに移動する
      # ログインページに遷移したことを確認する
    end
  end
end
