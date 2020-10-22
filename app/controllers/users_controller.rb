class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :move_to_index

  def show # マイページ機能
    @search = Item.ransack(params[:q])
    @items = Item.all.includes(:user).order('created_at DESC')

    @comments = @user.comments
    @my_items = @user.items.order('created_at DESC') # 出品した商品
    @comment_items = @items.joins(:comments).distinct.where(comments: { user_id: @user.id }).order('created_at DESC') # コメントした商品
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def move_to_index
    redirect_to root_path unless user_signed_in? && current_user.id == params[:id].to_i
  end
end
