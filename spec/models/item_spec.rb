require 'rails_helper'

RSpec.describe Item, type: :model do
  describe '商品出品機能' do
    before do
      @item = FactoryBot.build(:item)
    end

    context '商品出品がうまくいくとき' do
      it 'images, name, text, price, status_id, category_id, prefecture_id, day_id, delivery_charge_id,が存在すれば出品できる' do
        expect(@item).to be_valid
      end
      it 'priceが300以上であれば出品できる' do
        @item.price = 300
        expect(@item).to be_valid
      end
      it 'priceが9,999,999以下であれば出品できる' do
        @item.price = 9_999_999
        expect(@item).to be_valid
      end
      it 'priceが半角数字であれば出品できる' do
        @item.price = 55_555
        expect(@item).to be_valid
      end
    end

    context '商品出品がうまくいかないとき' do
      it 'imagesが空の場合は出品できない' do
        @item.images = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('出品画像を入力してください')
      end
      it 'nameが空の場合は出品できない' do
        @item.name = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('商品名を入力してください')
      end
      it 'textが空の場合は出品できない' do
        @item.text = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('商品の説明を入力してください')
      end
      it 'priceが空の場合は出品できない' do
        @item.price = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格を入力してください')
      end
      it 'priceが300未満の場合は出品できない' do
        @item.price = 299
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格は範囲内の金額で設定してください')
      end
      it 'priceが9,999,999より大きい場合は出品できない' do
        @item.price = 10_000_000
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格は範囲内の金額で設定してください')
      end
      it 'priceが全角数字の場合は出品できない' do
        @item.price = '７７７７'
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格は範囲内の金額で設定してください', '販売価格は半角数字で入力してください')
      end
      it 'status_idが0の場合は出品できない' do
        @item.status_id = 0
        @item.valid?
        expect(@item.errors.full_messages).to include('商品の状態を選択してください')
      end
      it 'category_idが0の場合は出品できない' do
        @item.category_id = 0
        @item.valid?
        expect(@item.errors.full_messages).to include('カテゴリーを選択してください')
      end
      it 'prefecture_idが0の場合は出品できない' do
        @item.prefecture_id = 0
        @item.valid?
        expect(@item.errors.full_messages).to include('発送元の地域を選択してください')
      end
      it 'day_idが0の場合は出品できない' do
        @item.day_id = 0
        @item.valid?
        expect(@item.errors.full_messages).to include('発送までの日数を選択してください')
      end
      it 'delivery_charge_idが0の場合は出品できない' do
        @item.delivery_charge_id = 0
        @item.valid?
        expect(@item.errors.full_messages).to include('配送料の負担を選択してください')
      end
      it 'userが紐付いてない場合は出品できない' do
        @item.user = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('購入ユーザを入力してください')
      end
    end
  end
end
