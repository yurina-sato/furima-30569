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
      attach_file '出品画像', "#{Rails.root}/public/images/test_image.png"
      fill_in '商品名', with: @item.name
      fill_in '商品の説明', with: @item.text
      select Category.find(@item.category_id).name, from: 'item-category' # カテゴリー
      select Status.find(@item.status_id).name, from: 'item-sales-status' # 商品の状態
      select DeliveryCharge.find(@item.delivery_charge_id).name, from: 'item-shipping-fee-status' # 配送料の負担
      select Prefecture.find(@item.prefecture_id).name, from: 'item-prefecture' # 発送元の地域
      select Day.find(@item.day_id).name, from: 'item-scheduled-delivery' # 発送までの日数
      fill_in '価格', with: @item.price
      # 送信するとItemモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Item.count }.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq root_path
      # 「出品が完了しました」の文字があることを確認する
      expect(page).to have_content('出品が完了しました。')
      # トップページには先ほど出品した商品が存在することを確認する（画像）
      expect(page).to have_selector 'img.item-img'
      # トップページには先ほど出品した商品が存在することを確認する（商品名）
      expect(page).to have_content(@item.name)
      # トップページには先ほど出品した商品が存在することを確認する（価格）
      expect(page).to have_content(@item.price)
    end
  end
  context '商品出品ができないとき'do
    it 'ログインしていないと商品出品ページに遷移できない' do
      # トップページに移動する
      basic_pass root_path
      # 商品出品ページへのリンクがあることを確認する
      expect(page).to have_content('出品する')
      # 商品出品ページに移動する
      visit new_item_path
      # ログインページに遷移したことを確認する
      expect(current_path).to eq new_user_session_path
    end
  end
end


RSpec.describe '商品編集', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end
  context '商品編集ができるとき' do
    it 'ログインしたユーザーは自分が出品した商品の編集ができる' do
      # 商品1を出品したユーザーでログインする
      # 商品1の詳細ページへ移動する
      # 商品1に「編集」ボタンがあることを確認する
      # 編集ページへ遷移する
      # すでに出品済みの内容がフォームに入っていることを確認する
      # 商品詳細を編集する
      # 編集してもItemモデルのカウントは変わらないことを確認する
      # 商品1の詳細ページへ遷移したことを確認する
      # 「商品の編集が完了しました。」の文字があることを確認する
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（商品名）
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（画像）
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（価格）
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（商品説明）
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（カテゴリー）
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（商品の状態）
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（配送料の負担）
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（発送元の地域）
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（発送日の目安）

    end
  end
  context '商品編集ができないとき' do
    it 'ログインしたユーザーは自分以外が出品した商品の編集画面には遷移できない' do
      # 商品1を出品したユーザーでログインする
      basic_pass new_user_session_path
      fill_in 'メールアドレス', with: @item1.user.email
      fill_in 'パスワード', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 商品2の詳細ページへ移動する
      visit item_path(@item2.id)
      # 商品2に「編集」ボタンがないことを確認する
      expect(page).to have_no_link '商品の編集', href: edit_item_path(@item2.id)
    end
    it 'ログインしていないと商品編集ページに遷移できない' do
      # トップページに移動する
      basic_pass root_path
      # 商品1の詳細ページへ移動する
      visit item_path(@item1.id)
      # 商品1に「編集」ボタンがないことを確認する
      expect(page).to have_no_link '商品の編集', href: edit_item_path(@item1.id)
      # トップページに移動する
      visit root_path
      # 商品2の詳細ページへ移動する
      visit item_path(@item2.id)
      # 商品2に「編集」ボタンがないことを確認する
      expect(page).to have_no_link '商品の編集', href: edit_item_path(@item2.id)
    end
  end
end


RSpec.describe '商品削除', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end
  context '商品削除ができるとき' do
    it 'ログインしたユーザーは自分が出品した商品の削除ができる' do
      # 商品1を出品したユーザーでログインする
      # 商品1の詳細ページへ移動する
      # 商品1に「削除」ボタンがあることを確認する
      # 商品を削除するとItemモデルのカウントが1減ることを確認する
      # トップページに遷移したことを確認する
      # 「商品を削除しました。」の文字があることを確認する
      # トップページには先ほど削除した商品が存在しないことを確認する（画像）
      # トップページには先ほど削除した商品が存在しないことを確認する（商品名）
      # トップページには先ほど削除した商品が存在しないことを確認する（価格）
    end
  end
  context '商品削除ができないとき' do
    it 'ログインしたユーザーは自分以外が出品した商品を削除できない' do
      # 商品1を出品したユーザーでログインする
      # 商品2の詳細ページへ移動する
      # 商品2に「削除」ボタンがないことを確認する
    end
    it 'ログインしていないと商品削除ボタンがない' do
      # トップページに移動する
      # 商品1の詳細ページへ移動する
      # 商品1に「削除」ボタンがないことを確認する
      # トップページに移動する
      # 商品2の詳細ページへ移動する
      # 商品2に「削除」ボタンがないことを確認する
    end
  end
end