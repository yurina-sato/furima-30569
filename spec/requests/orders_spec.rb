require 'rails_helper'

RSpec.describe OrdersController, type: :request do
  describe "GET #index" do
    def get_order(item_id) # basic認証
      username = ENV['FURIMA_BASIC_AUTH_USER']
      password = ENV['FURIMA_BASIC_AUTH_PASSWORD']
      get item_orders_path(item_id), headers: { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
    end

    context 'ユーザーがログインしている場合' do
      let(:user) { FactoryBot.create(:user) } # ログインするuserを予め作成

      before do
        login_as(user)  # sign_inヘルパーでログイン
        @item = FactoryBot.create(:item)
      end

      it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
        get_order(@item.id)
        expect(response.status).to eq 200 
      end
      it 'indexアクションにリクエストするとレスポンスに購入する商品の画僧の1枚目が存在する' do
        get_order(@item.id)
        expect(response.body).to include("test_image.png") # テスト用画像のファイル名
      end
      it 'indexアクションにリクエストするとレスポンスに購入する商品の商品名が存在する' do
        get_order(@item.id)
        expect(response.body).to include @item.name
      end
      it 'indexアクションにリクエストするとレスポンスに購入する商品の価格が存在する' do
        get_order(@item.id)
        expect(response.body).to include @item.price.to_s # 数値を文字列として取得
      end
      it 'indexアクションにリクエストすると、商品購入フォームが表示されている' do
        get_order(@item.id)
        expect(response).to render_template :index
      end
      it "indexアクションにリクエストすると、商品が売却済みの場合はトップページへリダイレクトする" do
        buy_user = FactoryBot.create(:user) # 購入userを作成
        order = Order.create(item_id: @item.id, user_id: buy_user.id) # @itemを売却済みの状態にする
        get_order(@item.id)
        expect(response).to redirect_to root_path  
      end
    end
    context 'ユーザーがログアウトしている場合' do
      it 'indexアクションにリクエストすると、ログインページへリダイレクトする' do
        @item = FactoryBot.create(:item)
        get_order(@item.id)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    def post_order(item_id, params) # basic認証と一緒に送るパラメータ
      username = ENV['FURIMA_BASIC_AUTH_USER']
      password = ENV['FURIMA_BASIC_AUTH_PASSWORD']
      token = 'hoge'
      post item_orders_path(item_id), headers: { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) },
                             params: { order_address: params, token: token }
    end
    context 'ユーザーがログインしている場合' do
      let(:user) { FactoryBot.create(:user) } # ログインするuserを予め作成

      def payjp_test # Payjp処理をモックでダミー化
        payjp_charge = double("Payjp::Charge")
        allow(Payjp).to receive(:api_key).and_return(true)
        allow(Payjp::Charge).to receive(:create).and_return(payjp_charge)
      end

      before do
        login_as(user)  # sign_inヘルパーでログイン
        @item = FactoryBot.create(:item) # テスト用に購入するitem作成        
        @order_address_params = FactoryBot.attributes_for(:order_address, user_id: user.id, item_id: @item.id) # 購入情報のパラメータ
        @invalid_order_address_params = FactoryBot.attributes_for(:order_address, postal_cord: nil, user_id: user.id, item_id: @item.id) # 不正なパラメータ
      end
      it 'createアクションをリクエストすると、正常に商品を購入できる' do
        expect do
          payjp_test
          post_order(@item.id, @order_address_params)
          # post item_orders_path(@item.id), params: { order_address: @order_address_params, token: @token }
        end.to change{ Order.count }.by 1
      end
      it 'createアクションをリクエストすると、正常に購入できた場合はトップページへリダイレクトする' do
        payjp_test
        post_order(@item.id, @order_address_params)
        expect(response).to redirect_to root_path
      end
      it 'createアクションをリクエストすると、パラメータが不正な場合は商品を購入できない' do
        expect do
          post_order(@item.id, @invalid_order_address_params)
        end.to_not change{ Item.count }
      end
      it 'createアクションをリクエストすると、正常に購入できない場合は購入情報ページへ戻る' do
        post_order(@item.id, @invalid_order_address_params)
        expect(response).to render_template :index
      end
      it "createアクションにリクエストすると、商品が売却済みの場合はトップページへリダイレクトする" do
        buy_user = FactoryBot.create(:user) # 出品者とは異なる購入userを作成
        order = Order.create(item_id: @item.id, user_id: buy_user.id) # @itemを売却済みの状態にする
        post_order(@item.id, @order_address_params)
        expect(response).to redirect_to root_path  
      end
    end
    context 'ユーザーがログアウトしている場合' do
      it 'createアクションにリクエストすると、ログインページへリダイレクトする' do
        @item = FactoryBot.create(:item)
        post_order(@item.id, @order_address_params)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
