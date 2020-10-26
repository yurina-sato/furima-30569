require 'rails_helper'

RSpec.describe CommentsController, type: :request do
  describe "POST #create" do
    context 'ユーザーがログインしている場合' do
      let(:user) { FactoryBot.create(:user) } # ログインするuserを予め作成

      before do
        login_as(user)  # sign_inヘルパーでログイン
        @item = FactoryBot.create(:item)
        @comments_params = FactoryBot.attributes_for(:comment, user_id: user.id, item_id: @item.id) # 投稿コメントのパラメータ
        @invalid_comments_params = FactoryBot.attributes_for(:comment, text: nil, user_id: user.id, item_id: @item.id) # 不正なパラメータ
      end

      it 'createアクションをリクエストすると、正常にコメントを投稿できる' do
        expect do
          post item_comments_path(@item.id), params: { comment: @comments_params }
        end.to change{ Comment.count }.by 1
      end
      it 'createアクションをリクエストすると、正常にコメント投稿ができた場合は商品詳細ページへリダイレクトする' do
        post item_comments_path(@item.id), params: { comment: @comments_params }
        expect(response).to redirect_to item_path(@item.id)
      end
      it 'createアクションをリクエストすると、パラメータが不正な場合はコメントを投稿できない' do
        expect do
          post item_comments_path(@item.id), params: { comment: @invalid_comments_params }
        end.to_not change{ Comment.count }
      end
      it 'createアクションをリクエストすると、正常にコメント投稿ができない場合は商品情報ページへ戻る'do
      post item_comments_path(@item.id), params: { comment: @invalid_comments_params }
      expect(response).to render_template 'items/show'
      end
    end
    context 'ユーザーがログアウトしている場合' do
      it 'createアクションにリクエストすると、ログインページへリダイレクトする' do
        @item = FactoryBot.create(:item)
        post item_orders_path(@item.id), params: { order_address: @order_address_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
