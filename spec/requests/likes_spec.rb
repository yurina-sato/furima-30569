require 'rails_helper'

RSpec.describe LikesController, type: :request do
  describe 'POST #create' do
    def post_likes(item_id, like_params) # basic認証と、一緒に送るパラメータ
      username = ENV['FURIMA_BASIC_AUTH_USER']
      password = ENV['FURIMA_BASIC_AUTH_PASSWORD']
      post item_likes_path(item_id), headers: { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) },
                                     params: { like: like_params }
    end

    context 'ユーザーがログインしている場合' do
      let(:user) { FactoryBot.create(:user) } # ログインするuserを予め作成

      before do
        login_as(user) # sign_inヘルパーでログイン
        @item = FactoryBot.create(:item)
        @like_params = FactoryBot.attributes_for(:like, user_id: user.id, item_id: @item.id) # likesパラメータ
      end

      it 'createアクションをリクエストすると、正常にお気に入り登録できる' do
        expect do
          post_likes(@item.id, @like_params)
          # post item_likes_path(@item.id), params: { like: @like_params }
        end.to change { Like.count }.by 1
      end
      it 'createアクションをリクエストすると、正常にお気に入り登録ができた場合は商品詳細ページへリダイレクトする' do
        post_likes(@item.id, @like_params)
        expect(response).to redirect_to item_path(@item.id)
      end
      it 'createアクションをリクエストすると、パラメータが不正な場合はお気に入り登録できない' do
        @like = Like.create(@like_params) # 一度お気に入り登録する
        expect do
          post_likes(@item.id, @like_params) # 同じ商品でもう一度お気に入り登録しようとする
        end.to_not change { Like.count }
      end
      it 'createアクションをリクエストすると、正常にお気に入り登録ができない場合は商品情報ページへ戻る' do
        @like = Like.create(@like_params) # 一度お気に入り登録する
        post_likes(@item.id, @like_params) # 同じ商品でもう一度お気に入り登録しようとする
        expect(response).to redirect_to item_path(@item.id)
      end
    end
    context 'ユーザーがログアウトしている場合' do
      it 'createアクションにリクエストすると、ログインページへリダイレクトする' do
        @item = FactoryBot.create(:item)
        post_likes(@item.id, @like_params)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    def get_item_show(item_id) # 商品詳細ページ basic認証
      username = ENV['FURIMA_BASIC_AUTH_USER']
      password = ENV['FURIMA_BASIC_AUTH_PASSWORD']
      get item_path(item_id), headers: { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
    end

    def delete_likes(item_id, like_id, like_params) # basic認証と、一緒に送るパラメータ
      username = ENV['FURIMA_BASIC_AUTH_USER']
      password = ENV['FURIMA_BASIC_AUTH_PASSWORD']
      delete item_like_path(item_id, like_id), headers: { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) },
                                               params: { id: like_params }
    end

    context 'ユーザーがログインしている場合' do
      let(:user) { FactoryBot.create(:user) } # ログインするuserを予め作成

      before do
        login_as(user) # sign_inヘルパーでログイン
        @item = FactoryBot.create(:item)
        @like = FactoryBot.create(:like, item_id: @item.id, user_id: user.id) # ログインユーザーで@itemをお気に入り登録
      end
      it 'お気に入り登録をした商品の詳細ページには、お気に入り削除のボタンが表示されている' do
        get_item_show(@item.id)
        expect(response.body).to include 'お気に入りから削除'
      end
      it 'destroyアクションをリクエストすると、正常にお気に入り登録を削除できる' do
        expect do
          delete_likes(@item.id, @like.id, @item.id)
        end.to change { Like.count }.by(-1)
      end
      it 'destroyアクションをリクエストすると、正常にお気に入り登録を削除できた場合は商品詳細ページへリダイレクトする' do
        delete_likes(@item.id, @like.id, @item.id)
        expect(response).to redirect_to item_path(@item.id)
      end
      it 'destroyアクションをリクエストすると、正常にお気に入り登録が削除できない場合は商品情報ページへ戻る' do
        invalid_like_params = { id: nil } # 不正なパラメータ
        delete_likes(@item.id, @like.id, invalid_like_params)
        expect(response).to redirect_to item_path(@item.id)
      end
    end
    context 'ユーザーがログアウトしている場合' do
      it 'destroyアクションにリクエストすると、ログインページへリダイレクトする' do
        @item = FactoryBot.create(:item)
        @like = FactoryBot.create(:like, item_id: @item.id) # ログインユーザーで@itemをお気に入り登録
        delete_likes(@item.id, @like.id, @item.id)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
