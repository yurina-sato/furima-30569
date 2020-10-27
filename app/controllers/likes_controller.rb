class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = Like.new(like_params)
    if @like.save
      redirect_to item_path(@like.item.id), notice: 'お気に入りに登録しました。'
    else
      flash.now[:alart] = 'お気に入りに登録できませんでした。'
      redirect_to item_path(@like.item.id)
    end
  end

  def destroy
    @like = Like.find_by(like_params)
    if @like.destroy
      redirect_to item_path(like_params[:item_id]), notice: 'お気に入りから削除しました。'
    else
      flash.now[:alart] = 'お気に入りから削除できませんでした。'
      redirect_to item_path(@like.item.id)
    end
  end

  private

  def like_params
    params.permit(:like).merge(item_id: params[:item_id], user_id: current_user.id)
  end
end
