require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe "GET #show" do # 自作アクション(マイページ機能)
    def get_mypage(user_id) # basic認証
      username = ENV['FURIMA_BASIC_AUTH_USER']
      password = ENV['FURIMA_BASIC_AUTH_PASSWORD']
      get user_path(user_id), headers: { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
    end
    
    let(:user) { FactoryBot.create(:user) } # ログインするuserを予め作成

    context 'ユーザーがログインしている場合' do
      before do
        login_as(user)  # sign_inヘルパーでログイン
        @my_item = FactoryBot.create(:item, user_id: user.id) # 商品を出品
        @my_items = user.items # 出品した商品を取得
        @items = Item.all.includes(:user) # 全商品を取得
        @comment = FactoryBot.create(:comment, user_id: user.id) # コメントを作成
        @like = FactoryBot.create(:like, user_id: user.id) # likesを作成
        @like_items = @items.joins(:likes).distinct.where(likes: { user_id: user.id }) # お気に入りに登録した商品
        @comment_items = @items.joins(:comments).distinct.where(comments: { user_id: user.id }) # コメントした商品
      end

      it "showアクションにリクエストすると正常にレスポンスが返ってくる" do 
        get_mypage(user.id)
        expect(response.status).to eq 200
      end

      it "showアクションにリクエストするとレスポンスにお気に入り商品の商品名が存在する" do 
        get_mypage(user.id)
        @like_items.each do |like_item|
          expect(response.body).to include like_item.name
        end
      end
      it "showアクションにリクエストするとレスポンスにお気に入り商品の画僧の1枚目が存在する" do 
        get_mypage(user.id)
        @like_items.each do |like_item|
          expect(response.body).to include("test_image.png") # テスト用画像のファイル名
        end
      end
      it "showアクションにリクエストするとレスポンスにお気に入り商品の価格が存在する" do 
        get_mypage(user.id)
        @like_items.each do |like_item|
          expect(response.body).to include like_item.price.to_s # 数値を文字列として取得
        end
      end
      it "showアクションにリクエストするとレスポンスにお気に入り商品のお気に入り登録数が存在する" do 
        get_mypage(user.id)
        @like_items.each do |like_item|
          expect(response.body).to include like_item.likes.count.to_s # 数値を文字列として取得
        end
      end
      it 'showアクションにリクエストすると、お気に入り商品が売却済みの場合はSold Out!!が表示されている' do
        buy_user = FactoryBot.create(:user) # 出品者とは異なる購入userを作成
        order = Order.create(item_id: @like.item.id, user_id: buy_user.id) # @お気に入り登録した商品を売却済みの状態にする
        get_mypage(user.id)
        @like_items.each do |like_item|
          expect(response.body).to include "Sold Out!!"  
        end
      end

      it "showアクションにリクエストするとレスポンスにコメントした商品の商品名が存在する" do 
        get_mypage(user.id)
        @comment_items.each do |comment_item|
          expect(response.body).to include comment_item.name
        end
      end
      it "showアクションにリクエストするとレスポンスにコメントしたの画僧の1枚目が存在する" do 
        get_mypage(user.id)
        @comment_items.each do |comment_item|
          expect(response.body).to include("test_image.png") # テスト用画像のファイル名
        end
      end
      it "showアクションにリクエストするとレスポンスにコメントしたの価格が存在する" do 
        get_mypage(user.id)
        @comment_items.each do |comment_item|
          expect(response.body).to include comment_item.price.to_s # 数値を文字列として取得
        end
      end
      it "showアクションにリクエストするとレスポンスにコメントしたのお気に入り登録数が存在する" do 
        get_mypage(user.id)
        @comment_items.each do |comment_item|
          expect(response.body).to include comment_item.likes.count.to_s  # 数値を文字列として取得
        end
      end
      it 'showアクションにリクエストすると、コメントしたが売却済みの場合はSold Out!!が表示されている' do
        buy_user = FactoryBot.create(:user) # 出品者とは異なる購入userを作成
        order = Order.create(item_id: @comment.item.id, user_id: buy_user.id) # @コメントした商品を売却済みの状態にする
        get_mypage(user.id)
        @comment_items.each do |comment_item|
          expect(response.body).to include "Sold Out!!"  
        end
      end

      it "showアクションにリクエストするとレスポンスに出品した商品の商品名が存在する" do 
        get_mypage(user.id)
        @my_items.each do |my_item|
          expect(response.body).to include my_item.name
        end
      end
      it "showアクションにリクエストするとレスポンスに出品したの画僧の1枚目が存在する" do 
        get_mypage(user.id)
        @my_items.each do |my_item|
          expect(response.body).to include("test_image.png") # テスト用画像のファイル名
        end
      end
      it "showアクションにリクエストするとレスポンスに出品したの価格が存在する" do 
        get_mypage(user.id)
        @my_items.each do |my_item|
          expect(response.body).to include my_item.price.to_s # 数値を文字列として取得
        end
      end
      it "showアクションにリクエストするとレスポンスに出品したのお気に入り登録数が存在する" do 
        get_mypage(user.id)
        @my_items.each do |my_item|
          expect(response.body).to include my_item.likes.count.to_s # 数値を文字列として取得
        end
      end
      it 'showアクションにリクエストすると、出品したが売却済みの場合はSold Out!!が表示されている' do
        buy_user = FactoryBot.create(:user) # 出品者とは異なる購入userを作成
        order = Order.create(item_id: @my_item.id, user_id: buy_user.id) # @出品した商品を売却済みの状態にする
        get_mypage(user.id)
        @my_items.each do |my_item|
          expect(response.body).to include "Sold Out!!"  
        end
      end

      it "showアクションにリクエストするとレスポンスに商品検索フォームが存在する" do 
        get_mypage(user.id)
        expect(response.body).to include "キーワードから検索する"    
      end
    end
    context 'ユーザーがログアウトしている場合'do
      it "showアクションにリクエストすると、ログインページへリダイレクトする" do
        get_mypage(user.id)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
