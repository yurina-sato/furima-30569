class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :move_to_index, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @items = Item.all.includes(:user).order('created_at DESC')
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: "出品が完了しました。"
    else
      @item.images = nil # 画像プレビューを空にする
      render :new
    end
  end

  
  def update
    if @item.update(item_params)
      redirect_to item_path(@item.id), notice: "商品の編集が完了しました。"
    else
      render :edit
    end
  end

  def destroy
    if @item.destroy
      redirect_to root_path, notice: "商品を削除しました。"
    else
      render :show
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
end
