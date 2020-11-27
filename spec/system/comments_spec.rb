require 'rails_helper'

RSpec.describe "コメント投稿", type: :system do
  before do
    @item = FactoryBot.create(:item)
    @comment = FactoryBot.create(:comment, item_id: @item.id) # @itemへのコメント
  end

  it 'ログインしたユーザーは商品詳細ページでコメント投稿できる' do
    # ログインする
    # 商品詳細ページに遷移する
    # フォームに情報を入力する
    # コメントを送信すると、Commentモデルのカウントが1上がることを確認する
    # 詳細ページにリダイレクトされることを確認する
    # 詳細ページ上に先ほどのコメント内容が含まれていることを確認する
  end
  it 'ログインしていないと商品詳細ページでコメント投稿ができない' do
    # トップページに移動する
    # 商品詳細ページに遷移する
    # 商品詳細ページにコメント投稿フォームがないことを確認する
  end

end
