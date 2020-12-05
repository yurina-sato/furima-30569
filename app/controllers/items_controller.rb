class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_search, only: [:index, :show]
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :move_to_index, only: [:edit, :update, :destroy]

  def index
    @items = Item.where(checked: false).with_attached_images.includes(:order, :likes, :user).order('created_at DESC') # N+1問題対策、売却済商品は表示設定分
  end

  def show
    @comment = Comment.new
    @comments = @item.comments.includes(:user)
    @like = Like.new
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params, checked: false)
    if @item.save
      redirect_to root_path, notice: '出品が完了しました。'
    else
      @item.images = nil # 画像プレビューを空にする
      render :new
    end
  end

  def update
    if @item.update(item_params, checked: false)
      redirect_to item_path(@item.id), notice: '商品の編集が完了しました。'
    else
      render :edit
    end
  end

  def destroy
    if @item.destroy
      redirect_to root_path, notice: '商品を削除しました。'
    else
      flash.now[:alart] = '削除できない商品です。'
      redirect_to root_path
    end
  end

  def search
    if !search_params.nil?
      keywords = search_params[:name_or_text_cont].split(/[\p{blank}\s]+/) # キーワードを分割した配列に入れ直し
      grouping_hash = keywords.reduce({}) { |hash, word| hash.merge(word => { name_or_text_cont: word }) } # 分割したキーワードをransackに渡すパラメーターに組み立て直す
      @search = Item.ransack({ combinator: 'and', groupings: grouping_hash }) # ransackにパラメーターを渡し、ヒットした値をオブジェクト化
      @items = @search.result(distinct: true).order('created_at DESC') # オブジェクトの結果をビューの@itemsに渡す
    else
      @search = Item.ransack(search_params)
      @items = @search.result(distinct: true).order('created_at DESC')
    end
  end

  def checked # 売却済商品の非表示を選択可能に
    @item = Item.find(params[:id])
    if @item.checked == true
      @item.update(checked: false)
      redirect_to item_path(@item.id), notice: '表示設定をしました。'
    elsif @item.checked == false
      @item.update(checked: true)
      redirect_to item_path(@item.id), notice: '非表示に設定しました。'
    else
      flash.now[:alart] = '非表示設定のできない商品です。'
      redirect_to item_path(@item.id)
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :text, :price, :status_id, :category_id, :prefecture_id, :day_id, :delivery_charge_id, images: []).merge(user_id: current_user.id)
  end

  def move_to_index
    redirect_to root_path unless user_signed_in? && current_user.id == @item.user.id && @item.order.nil?
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def search_params
    params.require(:q).permit(:name_or_text_cont)
  end

  def set_search
    @search = Item.ransack(params[:q])
  end
end
