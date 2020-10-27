require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'コメント投稿機能' do
    before do
      @comment = FactoryBot.build(:comment)
    end

    context 'コメント投稿がうまくいくとき' do
      it 'textが存在すればコメント投稿ができる' do
        expect(@comment).to be_valid
      end
    end

    context 'コメント投稿がうまくいかないとき' do
      it 'textが空の場合はコメント投稿ができない' do
        @comment.text = ''
        @comment.valid?
        expect(@comment.errors.full_messages).to include('コメント文を入力してください')
      end
      it 'userが紐付いてない場合はコメント投稿ができない' do
        @comment.user = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('コメントユーザを入力してください')
      end
      it 'itemが紐付いてない場合はコメント投稿ができない' do
        @comment.item = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('商品を入力してください')
      end
    end
  end
end
