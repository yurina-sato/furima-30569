require 'rails_helper'

RSpec.describe LikesController, type: :request do
  describe "POST #create" do
    context 'ユーザーがログインしている場合' do
      let(:user) { FactoryBot.create(:user) } # ログインするuserを予め作成

      before do
        login_as(user)  # sign_inヘルパーでログイン
        @item = FactoryBot.create(:item)
        @like_params = FactoryBot.attributes_for(:like, user_id: user.id, item_id: @item.id) # likesパラメータ
        @invalid_like_params = FactoryBot.attributes_for(:like, user_id: nil, item_id: @item.id) # 不正なパラメータ
      end

      it 'createアクションをリクエストすると、正常にお気に入り登録できる' do
        expect do
          post item_likes_path(@item.id), params: { like: @like_params }
        end.to change{ Like.count }.by 1
      end
      it 'createアクションをリクエストすると、正常にお気に入り登録ができた場合は商品詳細ページへリダイレクトする' do
        post item_likes_path(@item.id), params: { like: @like_params }
        expect(response).to redirect_to item_path(@item.id)
      end
      it 'createアクションをリクエストすると、パラメータが不正な場合はお気に入り登録できない' do
        expect do
          post item_likes_path(@item.id), params: { like: @invalid_like_params }
        end.to_not change{ Comment.count }
      end
      it 'createアクションをリクエストすると、正常にお気に入り登録ができない場合は商品情報ページへ戻る'do
      post item_likes_path(@item.id), params: { like: @invalid_like_params }
      expect(response).to redirect_to item_path(@item.id)
      end
    end
    context 'ユーザーがログアウトしている場合' do
      it 'createアクションにリクエストすると、ログインページへリダイレクトする' do
        @item = FactoryBot.create(:item)
        post item_likes_path(@item.id), params: { like: @like_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE #destroy" do
    context 'ユーザーがログインしている場合' do
      let(:user) { FactoryBot.create(:user) } # ログインするuserを予め作成

      before do
        login_as(user)  # sign_inヘルパーでログイン
        @item = FactoryBot.create(:item)
        @like = FactoryBot.create(:like, item_id: @item.id, user_id: user.id) # ログインユーザーで@itemをお気に入り登録
        @invalid_like_params = {id: nil} # 不正なパラメータ
      end
      it 'お気に入り登録をした商品の詳細ページには、お気に入り削除のボタンが表示されている' do
        get item_path(@item.id)
        expect(response.body).to include "お気に入りから削除"    
      end
      it 'destroyアクションをリクエストすると、正常にお気に入り登録を削除できる' do
        expect do
          delete item_like_path(@item.id, @like.id), params: { id: @item.id }
        end.to change{ Like.count }.by(-1)
      end
      it 'destroyアクションをリクエストすると、正常にお気に入り登録を削除できた場合は商品詳細ページへリダイレクトする' do
        delete item_like_path(@item.id, @like.id), params: { id: @item.id }
        expect(response).to redirect_to item_path(@item.id)
      end
      it 'destroyアクションをリクエストすると、パラメータが不正な場合はお気に入り登録が削除されない' do
        expect do
          delete item_like_path(@item.id, @like.id), params: { id: @item.id }
        end.to_not change{ Comment.count }
      end
      it 'createアクションをリクエストすると、正常にお気に入り登録ができない場合は商品情報ページへ戻る'do
      post item_likes_path(@item.id, @like.id), params: { like: @invalid_like_params }
      expect(response).to redirect_to item_path(@item.id)
      end
    end
    context 'ユーザーがログアウトしている場合' do
      it 'destroyアクションにリクエストすると、ログインページへリダイレクトする' do
        @item = FactoryBot.create(:item)
        @like = FactoryBot.create(:like, item_id: @item.id) # ログインユーザーで@itemをお気に入り登録
        delete item_like_path(@item.id, @like.id), params: { id: @item.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
