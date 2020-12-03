require 'rails_helper'

RSpec.describe 'コメント投稿', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
    @comment = FactoryBot.build(:comment, user_id: @user.id, item_id: @item.id) # @userが@itemへコメント
  end

  it 'ログインしたユーザーは商品詳細ページでコメント投稿できる' do
    # ログインする
    sign_in(@user)
    # 商品詳細ページに遷移する
    visit item_path(@item.id)
    # フォームに情報を入力する
    fill_in 'comment_text', with: @comment.text
    # コメントを送信すると、Commentモデルのカウントが1上がることを確認する
    expect  do
      find('input[name="commit"]').click
    end.to change { Comment.count }.by(1)
    # 「コメントを投稿しました。」の文字があることを確認する
    expect(page).to have_content('コメントを投稿しました。')
    # 詳細ページ上に先ほどのコメント内容が含まれていることを確認する(コメントしたuser名)
    expect(page).to have_content(@comment.user.nickname)
    # 詳細ページ上に先ほどのコメント内容が含まれていることを確認する(コメント文)
    expect(page).to have_content(@comment.text)
  end
  it 'ログインしていないと商品詳細ページでコメント投稿ができない' do
    # トップページに移動する
    basic_pass root_path
    # 商品詳細ページに遷移する
    visit item_path(@item.id)
    # 商品詳細ページにコメント投稿フォームがないことを確認する
    expect(page).to have_no_selector 'textarea.comment[text]' # 投稿フォーム
  end
end
