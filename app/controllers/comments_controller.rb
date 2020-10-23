class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.new(comments_params)
    if @comment.save
      redirect_to item_path(@comment.item.id), notice: 'コメントを投稿しました。'
    else
      @search = Item.ransack(params[:q])
      @item = Item.find(params[:item_id])
      @comments = @item.comments
      flash.now[:alart] = 'コメント文を入力してください'
      render 'items/show'
    end
  end

  private

  def comments_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, item_id: params[:item_id])
  end
end
