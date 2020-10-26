require 'rails_helper'

RSpec.describe ItemsController, type: :request do
  before do
    @item = FactoryBot.create(:item)
  end

  describe "GET #index" do
    it "indexアクションにリクエストすると正常にレスポンスが返ってくる" do 
      get root_path
      expect(response.status).to eq 200    
    end
    it "indexアクションにリクエストするとレスポンスに出品済み商品の商品名が存在する" do 
      get root_path
      expect(response.body).to include @item.name    
    end
    it "indexアクションにリクエストするとレスポンスに出品済み商品の価格が存在する" do 
      get root_path
      expect(response.body).to include @item.price.to_s # 数値を文字列として取得
    end
    it "indexアクションにリクエストするとレスポンスに出品済み商品のお気に入り登録数が存在する" do 
      get root_path
      expect(response.body).to include @item.likes.count.to_s # 数値を文字列として取得
    end
    it "indexアクションにリクエストするとレスポンスに出品済み商品の画僧の1枚目が存在する" do 
      get root_path
      expect(response.body).to include("test_image.png") # テスト用画像のファイル名
    end
    it "indexアクションにリクエストするとレスポンスに商品検索フォームが存在する" do 
      get root_path
      expect(response.body).to include "キーワードから検索する"    
    end
    it 'indexアクションにリクエストすると、商品が売却済みの場合はSold Out!!が表示されている' do
      buy_user = FactoryBot.create(:user) # 出品者とは異なる購入userを作成
      order = Order.create(item_id: @item.id, user_id: buy_user.id) # @itemを売却済みの状態にする
      get root_path
      expect(response.body).to include "Sold Out!!"
    end
  end

  describe "GET #show" do
    it "showアクションにリクエストすると正常にレスポンスが返ってくる" do 
      get item_path(@item.id)
      expect(response.status).to eq 200    
    end
    it "showアクションにリクエストするとレスポンスに出品済み商品の商品名が存在する" do 
      get item_path(@item.id)
      expect(response.body).to include @item.name    
    end
    it "showアクションにリクエストするとレスポンスに出品済み商品の画僧の1枚目が存在する" do 
      get item_path(@item.id)
      expect(response.body).to include("test_image.png") # テスト用画像のファイル名
    end
    it "showアクションにリクエストするとレスポンスに出品済み商品の価格が存在する" do 
      get item_path(@item.id)
      expect(response.body).to include @item.price.to_s # 数値を文字列として取得
    end
    it "showアクションにリクエストするとレスポンスに出品済み商品の説明文が存在する" do 
      get item_path(@item.id)
      expect(response.body).to include @item.text
    end
    it "showアクションにリクエストするとレスポンスに出品済み商品の出品者名が存在する" do 
      get item_path(@item.id)
      expect(response.body).to include @item.user.nickname
    end
    it "showアクションにリクエストするとレスポンスに出品済み商品のカテゴリーが存在する" do 
      get item_path(@item.id)
      expect(response.body).to include @item.category.name
    end
    it "showアクションにリクエストするとレスポンスに出品済み商品の状態が存在する" do 
      get item_path(@item.id)
      expect(response.body).to include @item.status.name
    end
    it "showアクションにリクエストするとレスポンスに出品済み商品の配送料の負担が存在する" do 
      get item_path(@item.id)
      expect(response.body).to include @item.delivery_charge.name
    end
    it "showアクションにリクエストするとレスポンスに出品済み商品の発送元地域が存在する" do 
      get item_path(@item.id)
      expect(response.body).to include @item.prefecture.name
    end
    it "showアクションにリクエストするとレスポンスに出品済み商品の発送日の目安が存在する" do 
      get item_path(@item.id)
      expect(response.body).to include @item.day.name
    end
    it 'showアクションをリクエストすると、お気に入り登録のボタンが表示されている' do
      get item_path(@item.id)
      expect(response.body).to include "お気に入り"    
    end
    it "showアクションにリクエストすると、出品済み商品へのコメントが存在する場合は表示されている" do 
      comment = FactoryBot.create(:comment, item_id: @item.id)
      get item_path(@item.id)
      @item.comments.each do |comment|
        expect(response.body).to include comment.text
      end
    end
    it "showアクションにリクエストするとレスポンスに商品検索フォームが存在する" do 
      get item_path(@item.id)
      expect(response.body).to include "キーワードから検索する"    
    end
    it 'showアクションにリクエストすると、商品が売却済みの場合はSold Out!!が表示されている' do
      buy_user = FactoryBot.create(:user) # 出品者とは異なる購入userを作成
      order = Order.create(item_id: @item.id, user_id: buy_user.id) # @itemを売却済みの状態にする
      get item_path(@item.id)
      expect(response.body).to include "Sold Out!!"
    end
  end

  describe "GET #new" do
    context 'ユーザーがログインしている場合' do
      let(:user) { FactoryBot.create(:user) } # ログインするuserを予め作成

      before do
        login_as(user)  # sign_inヘルパーでログイン
      end

      it "newアクションにリクエストすると正常にレスポンスが返ってくる" do
        get new_item_path
        expect(response.status).to eq 200   
      end
      it "newアクションにリクエストすると、商品出品フォームが表示されている" do
        get new_item_path
        expect(response).to render_template :new
      end
    end
    context 'ユーザーがログアウトしている場合' do
      it "newアクションにリクエストすると、ログインページへリダイレクトする" do
        get new_item_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    context 'ユーザーがログインしている場合' do
      let(:user) { FactoryBot.create(:user) } # ログインするuserを予め作成

      before do
        login_as(user)  # sign_inヘルパーでログイン
        @item_params = FactoryBot.attributes_for(:item, user_id: user.id,
          images: [Rack::Test::UploadedFile.new(File.join(Rails.root,'spec/fixtures/test_image.png'), 'image/png')]
          # テスト画像をパラメーター化して配列で渡す
        )
        @invalid_item_params = FactoryBot.attributes_for(:item, user_id: user.id, images: nil) # 不正なパラメータ
      end
      it 'createアクションをリクエストすると、正常に商品を出品できる' do
        expect do
          post items_path, params: { item: @item_params }
        end.to change{ Item.count }.by 1
      end
      it 'createアクションをリクエストすると、正常に出品できた場合はトップページへリダイレクトする' do
        post items_path, params: { item: @item_params }
        expect(response).to redirect_to root_path
      end
      it 'createアクションをリクエストすると、パラメータが不正な場合は商品が保存されない' do
        expect do
          post items_path, params: { item: @invalid_item_params }
        end.to_not change{ Item.count }
      end
      it 'createアクションをリクエストすると、正常に出品できない場合は出品ページへ戻る' do
        post items_path, params: { item: @invalid_item_params }
        expect(response).to render_template :new
      end
    end
    context 'ユーザーがログアウトしている場合' do
      it 'createアクションをリクエストすると、ログインページへリダイレクトする' do
        post items_path, params: { item: @item_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #edit" do
    context 'ユーザーがログインしている場合' do
      let(:user) { FactoryBot.create(:user) } # ログインするuserを予め作成

      before do
        login_as(user)  # sign_inヘルパーでログイン
        @item = FactoryBot.create(:item, user_id: user.id)
      end

      it "editアクションにリクエストすると正常にレスポンスが返ってくる" do
        get edit_item_path(@item.id)
        expect(response.status).to eq 200   
      end
      it "editアクションにリクエストすると、商品編集フォームが表示されている" do
        get edit_item_path(@item.id)
        expect(response).to render_template :edit
      end
      it "editアクションにリクエストするとレスポンスに、出品済み商品の現在の商品名が存在する" do 
        get edit_item_path(@item.id)
        expect(response.body).to include @item.name    
      end
      it "editアクションにリクエストするとレスポンスに、出品済み商品の現在の画僧1枚目が存在する" do 
        get edit_item_path(@item.id)
        expect(response.body).to include("test_image.png") # テスト用画像のファイル名
      end
      it "editアクションにリクエストするとレスポンスに、出品済み商品の現在の価格が存在する" do 
        get edit_item_path(@item.id)
        expect(response.body).to include @item.price.to_s # 数値を文字列として取得
      end
      it "editアクションにリクエストするとレスポンスに、出品済み商品の現在の説明文が存在する" do 
        get edit_item_path(@item.id)
        expect(response.body).to include @item.text
      end
      it "editアクションにリクエストするとレスポンスに、出品済み商品の現在のカテゴリーが存在する" do 
        get edit_item_path(@item.id)
        expect(response.body).to include @item.category.name
      end
      it "editアクションにリクエストするとレスポンスに、出品済み商品の現在の状態が存在する" do 
        get edit_item_path(@item.id)
        expect(response.body).to include @item.status.name
      end
      it "editアクションにリクエストするとレスポンスに、出品済み商品の現在の配送料の負担が存在する" do 
        get edit_item_path(@item.id)
        expect(response.body).to include @item.delivery_charge.name
      end
      it "editアクションにリクエストするとレスポンスに、出品済み商品の現在の発送元地域が存在する" do 
        get edit_item_path(@item.id)
        expect(response.body).to include @item.prefecture.name
      end
      it "editアクションにリクエストするとレスポンスに、出品済み商品の現在の発送日の目安が存在する" do 
        get edit_item_path(@item.id)
        expect(response.body).to include @item.day.name
      end
      it "editアクションにリクエストすると、出品者以外のユーザーの場合はトップページへリダイレクトする" do
        logout(user) # beforeで設定したの出品者ユーザーは一旦ログアウト
        another_user = FactoryBot.create(:user) # 出品者とは異なるログインuserを作成
        login_as(another_user)  # sign_inヘルパーでログイン
        get edit_item_path(@item.id)
        expect(response).to redirect_to root_path  
      end
      it "editアクションにリクエストすると、商品が売却済みの場合はトップページへリダイレクトする" do
        buy_user = FactoryBot.create(:user) # 出品者とは異なる購入userを作成
        order = Order.create(item_id: @item.id, user_id: buy_user.id) # @itemを売却済みの状態にする
        get edit_item_path(@item.id)
        expect(response).to redirect_to root_path   
      end
    end
    context 'ユーザーがログアウトしている場合' do
      it "editアクションにリクエストすると、ログインページへリダイレクトする" do
        get edit_item_path(@item.id)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH #update" do
    context 'ユーザーがログインしている場合' do
      let(:user) { FactoryBot.create(:user) } # ログインするuserを予め作成

      before do
        login_as(user)  # sign_inヘルパーでログイン
        @item = FactoryBot.create(:item, user_id: user.id) # ログインユーザーで一旦出品
        @item.update(name:  "hoge") # 属性値で商品名を編集
        @edit_item_params = @item.attributes # 編集した商品情報をパラメータで取得

        @invalid_item_params = FactoryBot.attributes_for(:item, name: nil, user_id: user.id) # 不正なパラメータ

      end
      it 'updateアクションをリクエストすると、正常に商品を編集できる' do
        patch item_path(@item.id), params: { id: @item.id, item: @edit_item_params }
        expect(@item.name).to eq "hoge"
      end
      it 'updateアクションをリクエストすると、正常に出品できた場合は商品詳細ページへリダイレクトする' do
        patch item_path(@item.id), params: { id: @item.id, item: @edit_item_params }
        expect(response).to redirect_to item_path(@item.id)
      end
      it 'updateアクションをリクエストすると、パラメータが不正な場合は商品が編集されない' do
        @item = FactoryBot.create(:item, user_id: user.id) # ログインユーザーで一旦出品
        expect do
          patch item_path(@item.id), params: { id: @item.id, item: @invalid_item_params }
        end.to_not change{ @item.name }
      end
      it 'updateアクションをリクエストすると、正常に編集できない場合は商品編集ページへ戻る' do
        patch item_path(@item.id), params: { id: @item.id, item: @invalid_item_params }
        expect(response).to render_template :edit
      end
      it "updateアクションにリクエストすると、出品者以外のユーザーの場合はトップページへリダイレクトする" do
        logout(user) # beforeで設定したの出品者ユーザーは一旦ログアウト
        another_user = FactoryBot.create(:user) # 出品者とは異なるログインuserを作成
        login_as(another_user)  # sign_inヘルパーでログイン
        patch item_path(@item.id), params: { id: @item.id, item: @edit_item_params }
        expect(response).to redirect_to root_path  
      end
      it "updateアクションにリクエストすると、商品が売却済みの場合はトップページへリダイレクトする" do
        buy_user = FactoryBot.create(:user) # 出品者とは異なる購入userを作成
        order = Order.create(item_id: @item.id, user_id: buy_user.id) # @itemを売却済みの状態にする
        patch item_path(@item.id), params: { id: @item.id, item: @edit_item_params }
        expect(response).to redirect_to root_path  
      end
    end
    context 'ユーザーがログアウトしている場合' do
      it 'updateアクションをリクエストすると、ログインページへリダイレクトする' do
        patch item_path(@item.id), params: { id: @item.id, item: @edit_item_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE #destroy" do
    context 'ユーザーがログインしている場合' do
      let(:user) { FactoryBot.create(:user) } # ログインするuserを予め作成

      before do
        login_as(user)  # sign_inヘルパーでログイン
        @item = FactoryBot.create(:item, user_id: user.id) # ログインユーザーで一旦出品
        @invalid_item_params = {id: nil} # 不正なパラメータ
      end

      it 'destroyアクションをリクエストすると、正常に商品を削除できる' do
        expect do
          delete item_path(@item.id), params: { id: @item.id }
        end.to change{ Item.count }.by(-1)
      end
      it 'destroyアクションをリクエストすると、正常に削除できた場合はトップページへリダイレクトする' do
        delete item_path(@item.id), params: { id: @item.id }
        expect(response).to redirect_to root_path
      end
      it 'destroyアクションをリクエストすると、パラメータが不正な場合は商品が削除されない' do
        delete item_path(@item.id), params: { id: @invalid_item_params }
        expect(response).to redirect_to root_path 
      end
      it 'destroyアクションをリクエストすると、出品者以外のユーザーの場合はトップページへリダイレクトする' do
        logout(user) # beforeで設定したの出品者ユーザーは一旦ログアウト
        another_user = FactoryBot.create(:user) # 出品者とは異なるログインuserを作成
        login_as(another_user)  # sign_inヘルパーでログイン
        delete item_path(@item.id), params: { id: @item.id }
        expect(response).to redirect_to root_path  
      end
      it 'destroyアクションをリクエストすると、商品が売却済みの場合はトップページへリダイレクトする' do
        buy_user = FactoryBot.create(:user) # 出品者とは異なる購入userを作成
        order = Order.create(item_id: @item.id, user_id: buy_user.id) # @itemを売却済みの状態にする
        delete item_path(@item.id), params: { id: @item.id }
        expect(response).to redirect_to root_path  
      end
    end
    context 'ユーザーがログアウトしている場合' do
      it 'destroyアクションをリクエストすると、ログインページへリダイレクトする' do
        delete item_path(@item.id), params: { id: @item.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #search" do
    before do
      # binding.pry
      @keyword = @item.name
      @keyword_params = { name_or_text_cont: @keyword } # 商品名を検索キーワードのパラメータに変換
    end
    it 'searchアクションにリクエストすると、正常にレスポンスが返ってくる' do
      get search_items_path, params: { q: @keyword_params }
      expect(response.status).to eq 200  
    end
    it "searchアクションにリクエストすると、商品検索結果フォームが表示されている" do
      get search_items_path, params: { q: @keyword_params }
      expect(response).to render_template :search
    end
    it 'searchアクションにリクエストすると、検索キーワードと一致する商品名か商品説明があれば、商品が表示されている' do
      get search_items_path, params: { q: @keyword_params }
      expect(response.body).to include @item.name
    end
    it 'searchアクションにリクエストすると、検索キーワードと一致する商品名か商品説明がなければ、商品が表示されない' do
      @item.destroy # 商品を削除
      get search_items_path, params: { q: @keyword_params }
      expect(response.body).to_not include @item.name
    end
    it 'searchアクションにリクエストすると、検索キーワードが空白であれば全商品が表示されている' do
      @keyword_params = { name_or_text_cont: " " }  # 検索キーワードを空白にする
      @items = Item.all.includes(:user)
      get search_items_path, params: { q: @keyword_params }
      @items.each do |item|
        expect(response.body).to include item.name
      end
    end
    it 'searchアクションにリクエストすると、複数検索キーワードが全て一致する商品名か商品説明があれば、商品名が表示されている' do
      @item = FactoryBot.create(:item, name: "hoge", text: "fuga")
      @keyword = @item.name
      @keyword_2 = @item.text # 2つ目の検索キーワードを作成
      @key_plus = @keyword + " " + @keyword_2 # 一旦検索ワードを空白でつないだ文字列にする
      @keyword_params = { name_or_text_cont: @key_plus } # 商品名を検索キーワードのパラメータに変換
      get search_items_path, params: { q: @keyword_params }
      expect(response.body).to include(@item.name)
    end
  end
end
