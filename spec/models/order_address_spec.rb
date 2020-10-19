require 'rails_helper'

RSpec.describe OrderAddress, type: :model do
  describe '商品購入' do
    before do
      @order_address = FactoryBot.build(:order_address)
      @user = FactoryBot.create(:user) # テスト用に購入するuser作成
      @item = FactoryBot.create(:item) # テスト用に購入するitem作成
      @order_address.user_id = @user.id # 購入userと紐付け
      @order_address.item_id = @item.id # 購入itemと紐付け
    end

    context '商品購入がうまくいくとき' do
      it 'クレジットカード情報(token), postal_cord, prefecture_id, city, house_number, building, phone_numberが存在していれば購入できる' do
        expect(@order_address).to be_valid
      end
      it 'buildingは空でも購入できる' do
        @order_address.building = nil
        expect(@order_address).to be_valid
      end
      it 'postal_cordは半角数字, 3桁-4桁であれば購入できる' do
        @order_address.postal_cord = '123-4567'
        expect(@order_address).to be_valid
      end
      it 'phone_numberは11桁以内の半角数字であれば購入できる' do
        @order_address.phone_number = '09012345678'
        expect(@order_address).to be_valid
      end
    end

    context '商品購入がうまくいかないとき' do
      it 'クレジットカード情報(token)が空である場合は購入出来ない' do
        @order_address.token = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('クレジットカード情報を入力してください')
      end
      it 'postal_cordが空である場合は購入出来ない' do
        @order_address.postal_cord = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('郵便番号を入力してください', '郵便番号はハイフンを入れて正しく入力してください')
      end
      it 'postal_cordにハイフンが含まれていない場合は購入出来ない' do
        @order_address.postal_cord = 1_234_567
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('郵便番号はハイフンを入れて正しく入力してください')
      end
      it 'postal_cordが全角数字である場合は購入出来ない' do
        @order_address.postal_cord = '１２３４５６７'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('郵便番号はハイフンを入れて正しく入力してください')
      end
      it 'postal_cordが3桁-4桁でない場合は購入出来ない' do
        @order_address.postal_cord = '1234-567'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('郵便番号はハイフンを入れて正しく入力してください')
      end
      it 'prefecture_idが0である場合は購入出来ない' do
        @order_address.prefecture_id = 0
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('都道府県を選択してください')
      end
      it 'cityが空である場合は購入出来ない' do
        @order_address.city = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('市区町村を入力してください')
      end
      it 'phone_numberが空である場合は購入出来ない' do
        @order_address.phone_number = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('電話番号を入力してください')
      end
      it 'phone_numberが全角数字である場合は購入出来ない' do
        @order_address.phone_number = '０９０１２３４５６７８'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('電話番号は半角数字で入力してください')
      end
      it 'phone_numberが11桁よりも多い場合は購入出来ない' do
        @order_address.phone_number = '090123456789'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('電話番号は11桁以内で入力してください')
      end
      it '購入情報(user_id, item_id)が紐付いていない場合は購入出来ない' do
        @order_address.user_id = nil
        @order_address.item_id = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('商品を入力してください', '購入ユーザを入力してください')
      end
    end
  end
end
