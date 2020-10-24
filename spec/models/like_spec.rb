require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'お気に入り機能' do
    before do
      @like = FactoryBot.build(:like)
    end

    context 'お気に入り登録がうまくいくとき' do
      it 'userとitemが存在すればお気に入り登録ができる' do
        expect(@like).to be_valid
      end
    end

    context 'お気に入り登録がうまくいかないとき' do
      it 'userが紐付いてない場合はお気に入り登録ができない' do
        @like.user = nil
        @like.valid?
        expect(@like.errors.full_messages).to include("お気に入り登録ユーザを入力してください")

      end
      it 'itemが紐付いてない場合はお気に入り登録ができない' do
        @like.item = nil
        @like.valid?
        expect(@like.errors.full_messages).to include("商品を入力してください")
      end
    end
  end
end
