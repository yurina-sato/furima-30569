require 'rails_helper'

def basic_pass(path) # basic認証
  username = ENV['FURIMA_BASIC_AUTH_USER']
  password = ENV['FURIMA_BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "商品購入", type: :system do
  def payjp_test # Payjp処理をモックでダミー化
    payjp_charge = double('Payjp::Charge')
    allow(Payjp).to receive(:api_key).and_return(true)
    allow(Payjp::Charge).to receive(:create).and_return(payjp_charge)
  end

  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
    @order_address = FactoryBot.build(:order_address)

    @sold_item = FactoryBot.create(:item) # 売却済み商品用
    @sold_order = FactoryBot.create(:order, item_id:@sold_item.id) # 売却済みの購入情報
    @sell_item = FactoryBot.create(:item, user_id: @user.id) # 自身の出品商品
  end
  context '商品購入ができるとき'do
    it 'ログインしたユーザーは商品購入ができる' do
      # ログインする
      # basic_pass new_user_session_path
      # fill_in 'メールアドレス', with: @user.email
      # fill_in 'パスワード', with: @user.password
      # find('input[name="commit"]').click
      # expect(current_path).to eq root_path
      # 商品詳細ページに移動する
      # visit item_path(@item.id)
      # 商品詳細ページに遷移する
      # visit item_orders_path(@item.id)
      # フォームに情報を入力する
      # クレジットの部分
      # fill_in '郵便番号', with: @order_address.postal_cord
      # select Prefecture.find(@order_address.prefecture_id).name, from: 'item-prefecture'
      # fill_in '市町村', with: @order_address.city
      # fill_in '番地', with: @order_address.house_number
      # fill_in '建物名', with: @order_address.building
      # fill_in '電話番号', with: @order_address.phone_number
      # 送信するとOrderモデルのカウントが1上がることを確認する
      # expect{
      #   find('input[name="commit"]').click
      # }.to change { Order.count }.by(1)
      # トップページへ遷移したことを確認する
      # expect(current_path).to eq root_path
      # 「購入手続きが完了しました。」の文字があることを確認する
      # expect(page).to have_content('購入手続きが完了しました。')
    end
  end
  context '商品購入ができないとき'do
    it '売却済みの商品は購入ページに遷移できない' do
      # ログインする
      basic_pass new_user_session_path
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 商品詳細ページに移動する
      visit item_path(@sold_item.id)
      # 商品詳細ページに「購入」ボタンがないことを確認する
      expect(page).to have_no_link '購入画面に進む', href: item_orders_path(@sold_item.id)
    end
    it '自身が出品した商品は購入ページに遷移できない' do
      # ログインする
      basic_pass new_user_session_path
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 商品詳細ページに移動する
      visit item_path(@sell_item.id)
      # 商品詳細ページに「購入」ボタンがないことを確認する
      expect(page).to have_no_link '購入画面に進む', href: item_orders_path(@sell_item.id)
    end
    it 'ログインしていないと商品購入ページに遷移できない' do
      # トップページに移動する
      basic_pass root_path
      # 商品詳細ページに遷移する
      visit item_path(@item.id)
       # 商品購入ページに移動する
      visit item_orders_path(@item.id)
      # ログインページに遷移したことを確認する
      expect(current_path).to eq new_user_session_path
    end
    
  end
end
