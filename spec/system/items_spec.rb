require 'rails_helper'

RSpec.describe '商品出品', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.build(:item)
  end
  context '商品出品ができるとき'do
    it 'ログインしたユーザーは商品出品ができる' do
      # ログインする
      sign_in(@user)
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
    @item1_edit = FactoryBot.build(:item)
    @item2 = FactoryBot.create(:item)
  end
  context '商品編集ができるとき' do
    it 'ログインしたユーザーは自分が出品した商品の編集ができる' do
      # 商品1を出品したユーザーでログインする
      sign_in(@item1.user)
      # 商品1の詳細ページへ移動する
      visit item_path(@item1.id)
      # 商品1に「編集」ボタンがあることを確認する
      expect(page).to have_link '商品の編集', href: edit_item_path(@item1.id)
      # 編集ページへ遷移する
      visit edit_item_path(@item1.id)
      # すでに出品済みの内容がフォームに入っていることを確認する
      expect(page).to have_selector 'img.item-img' # 画像プレビューが存在する
      expect(
        find('#item-name').value
      ).to eq @item1.name
      expect(
        find('#item-info').value
      ).to eq @item1.text
      expect(page).to have_select('カテゴリー', selected: Category.find(@item1.category_id).name)
      expect(page).to have_select('商品の状態', selected: Status.find(@item1.status_id).name)
      expect(page).to have_select('配送料の負担', selected: DeliveryCharge.find(@item1.delivery_charge_id).name)
      expect(page).to have_select('発送元の地域', selected: Prefecture.find(@item1.prefecture_id).name)
      expect(page).to have_select('発送までの日数', selected: Day.find(@item1.day_id).name)
      expect(
        find('#item-price').value
      ).to eq @item1.price.to_s
      # 商品詳細を編集する
      attach_file '出品画像', "#{Rails.root}/public/images/edit_test_image.png"
      fill_in '商品名', with: @item1_edit.name
      fill_in '商品の説明', with: @item1_edit.text
      select Category.find(@item1_edit.category_id).name, from: 'item-category' # カテゴリー
      select Status.find(@item1_edit.status_id).name, from: 'item-sales-status' # 商品の状態
      select DeliveryCharge.find(@item1_edit.delivery_charge_id).name, from: 'item-shipping-fee-status' # 配送料の負担
      select Prefecture.find(@item1_edit.prefecture_id).name, from: 'item-prefecture' # 発送元の地域
      select Day.find(@item1_edit.day_id).name, from: 'item-scheduled-delivery' # 発送までの日数
      fill_in '価格', with: @item1_edit.price
      # 編集してもItemモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Item.count }.by(0)
      # 商品1の詳細ページへ遷移したことを確認する
      expect(current_path).to eq item_path(@item1.id)
      # 「商品の編集が完了しました。」の文字があることを確認する
      expect(page).to have_content('商品の編集が完了しました。')
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（商品名）
      expect(page).to have_content(@item1_edit.name)
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（画像）
      expect(page).to have_selector 'img.item-box-img' # 画像が存在する
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（価格）
      expect(page).to have_content(@item1_edit.price)
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（商品説明）
      expect(page).to have_content(@item1_edit.text)
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（カテゴリー）
      expect(page).to have_content(Category.find(@item1_edit.category_id).name)
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（商品の状態）
      expect(page).to have_content(Status.find(@item1_edit.status_id).name)
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（配送料の負担）
      expect(page).to have_content(DeliveryCharge.find(@item1_edit.delivery_charge_id).name)
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（発送元の地域）
      expect(page).to have_content(Prefecture.find(@item1_edit.prefecture_id).name)
      # 商品1の詳細ページには先ほど変更した内容が存在することを確認する（発送日の目安）
      expect(page).to have_content(Day.find(@item1_edit.day_id).name)
    end
  end
  context '商品編集ができないとき' do
    it 'ログインしたユーザーは自分以外が出品した商品の編集画面には遷移できない' do
      # 商品1を出品したユーザーでログインする
      sign_in(@item1.user)
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
      sign_in(@item1.user)
      # 商品1の詳細ページへ移動する
      visit item_path(@item1.id)
      # 商品1に「削除」ボタンがあることを確認する
      expect(page).to have_link '削除', href: item_path(@item1.id)
      # 商品を削除するとItemモデルのカウントが1減ることを確認する
      expect{
        find_link('削除', href: item_path(@item1.id)).click
      }.to change { Item.count }.by(-1)
      # トップページに遷移したことを確認する
      expect(current_path).to eq root_path
      # 「商品を削除しました。」の文字があることを確認する
      expect(page).to have_content('商品を削除しました。')
      # トップページには先ほど削除した商品が存在しないことを確認する（詳細ページへのリンク）
      expect(page).to have_no_link href: item_path(@item1.id)
      # トップページには先ほど削除した商品が存在しないことを確認する（商品名）
      expect(page).to have_no_content(@item1.name)
      # トップページには先ほど削除した商品が存在しないことを確認する（価格）
      expect(page).to have_no_content(@item1.price)
    end
  end
  context '商品削除ができないとき' do
    it 'ログインしたユーザーは自分以外が出品した商品を削除できない' do
      # 商品1を出品したユーザーでログインする
      sign_in(@item1.user)
      # 商品2の詳細ページへ移動する
      visit item_path(@item2.id)
      # 商品2に「削除」ボタンがないことを確認する
      expect(page).to have_no_link '削除', href: item_path(@item2.id)
    end
    it 'ログインしていないと商品削除ボタンがない' do
      # トップページに移動する
      basic_pass root_path
      # 商品1の詳細ページへ移動する
      visit item_path(@item1.id)
      # 商品1に「削除」ボタンがないことを確認する
      expect(page).to have_no_link '削除', href: item_path(@item1.id)
      # トップページに移動する
      visit root_path
      # 商品2の詳細ページへ移動する
      visit item_path(@item2.id)
      # 商品2に「削除」ボタンがないことを確認する
      expect(page).to have_no_link '削除', href: item_path(@item2.id)
    end
  end
end