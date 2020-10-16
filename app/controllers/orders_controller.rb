class OrdersController < ApplicationController
  before_action :set_item
  before_action :move_to_index
  before_action :authenticate_user!

  def index
    @order_address = OrderAddress.new
  end

  def create
    @order_address = OrderAddress.new(order_address_params)
    if @order_address.valid?
      pay_item
      @order_address.save
      redirect_to root_path
    else
      render action: :index
    end
  end

  private

  def order_address_params # ストロングパラメーターを一つに統合
    params.require(:order_address).permit(:postal_cord, :prefecture_id, :city, :house_number, :building, :phone_number).merge(item_id: params[:item_id], user_id: current_user.id, price: @item.price, token: params[:token])
  end

  def move_to_index
    redirect_to root_path if user_signed_in? && current_user.id == @item.user.id || !@item.order.nil?
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def pay_item
    Payjp.api_key = ENV['PAYJP_SECRET_KEY'] # テスト秘密鍵
    Payjp::Charge.create(
      amount: order_address_params[:price],
      card: order_address_params[:token],
      currency: 'jpy'
    )
  end
end
