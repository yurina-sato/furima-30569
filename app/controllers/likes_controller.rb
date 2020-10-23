class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = Like.new(like_params)
    if @like.save
      redirect_to item_path(@like.item.id), notice: 'お気に入りに登録しました。'
    else
      @search = Item.ransack(params[:q])
      @item = Item.find(params[:item_id])
      @comments = @item.comments
      flash[:alart] = 'お気に入りに登録できませんでした。'
      render 'items/show'
    end
  end

  def destroy
    if @like = Like.find_by(like_params)
      @like.destroy
      redirect_to item_path(like_params[:item_id]), notice: 'お気に入りから削除しました。'
    else
      @search = Item.ransack(params[:q])
      @item = Item.find(like_params[:item_id])
      @comments = @item.comments
      flash[:alart] = 'お気に入りから削除できませんでした。'
      render 'items/show'
    end
  end

  private

  def like_params
    params.permit(:item_id).merge(user_id: current_user.id)
  end
end
