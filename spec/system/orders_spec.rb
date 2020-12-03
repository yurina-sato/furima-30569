require 'rails_helper'

RSpec.describe '商品購入', type: :system do
  def payjp_test # Payjp処理をモックでダミー化
    payjp_charge = double('Payjp::Charge')
    allow(Payjp).to receive(:api_key).and_return(true)
    allow(Payjp::Charge).to receive(:create).and_return(payjp_charge)
  end

  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
    @order_address = FactoryBot.build(:order_address, user_id: @user.id, item_id: @item.id)
  end
  context '商品購入ができるとき' do
    it 'ログインしたユーザーは商品購入ができる' do
      # ログインする
      sign_in(@user)
      # 商品詳細ページに移動する
      visit item_path(@item.id)
      # 商品詳細ページに遷移する
      visit item_orders_path(@item.id)
      # フォームに情報を入力する
      fill_in 'カード情報', with: '4242424242424242'
      fill_in 'card-exp-month', with: '1'
      fill_in 'card-exp-year', with: '23'
      fill_in 'セキュリティコード', with: '123'
      fill_in '郵便番号', with: @order_address.postal_cord
      select Prefecture.find(@order_address.prefecture_id).name, from: 'prefecture'
      fill_in '市区町村', with: @order_address.city
      fill_in '番地', with: @order_address.house_number
      fill_in '建物名', with: @order_address.building
      fill_in '電話番号', with: @order_address.phone_number
      # 購入ボタンをクリックする
      payjp_test # Payjpのモックを用意
      find('input[name="commit"]').click
      # トップページへ遷移し、「購入手続きが完了しました。」の文字があることを確認する
      expect(page).to have_content('購入手続きが完了しました。') # 先にhave_contentすることでリダイレクト処理を完了させる
      expect(current_path).to eq root_path
      # Orderモデルのカウントが1上がっていることを確認する
      expect(Order.count).to eq 1
    end
  end
  context '商品購入ができないとき' do
    it '売却済みの商品は購入ページに遷移できない' do
      @sold_item = FactoryBot.create(:item) # 売却済み商品用
      @sold_order = FactoryBot.create(:order, item_id: @sold_item.id) # 売却済みの購入情報

      # ログインする
      sign_in(@user)
      visit item_path(@sold_item.id)
      # 商品詳細ページに「購入」ボタンがないことを確認する
      expect(page).to have_no_link '購入画面に進む', href: item_orders_path(@sold_item.id)
    end
    it '自身が出品した商品は購入ページに遷移できない' do
      @sell_item = FactoryBot.create(:item, user_id: @user.id) # 自身の出品商品

      # ログインする
      sign_in(@user)
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
