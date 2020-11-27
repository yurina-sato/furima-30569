require 'rails_helper'

def basic_pass(path) # basic認証
  username = ENV['FURIMA_BASIC_AUTH_USER']
  password = ENV['FURIMA_BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "コメント投稿", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
    @comment = FactoryBot.build(:comment, user_id: @user.id, item_id: @item.id) # @userが@itemへコメント
  end

  it 'ログインしたユーザーは商品詳細ページでコメント投稿できる' do
    # ログインする
    basic_pass new_user_session_path
    fill_in 'メールアドレス', with: @user.email
    fill_in 'パスワード', with: @user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path
    # 商品詳細ページに遷移する
    visit item_path(@item.id)
    # フォームに情報を入力する
    fill_in 'comment_text', with: @comment.text
    # コメントを送信すると、Commentモデルのカウントが1上がることを確認する
    expect{
      find('input[name="commit"]').click
    }.to change { Comment.count }.by(1)
    # 「コメントを投稿しました。」の文字があることを確認する
    expect(page).to have_content('コメントを投稿しました。')
    # 詳細ページ上に先ほどのコメント内容が含まれていることを確認する(コメントしたuser名)
    expect(page).to have_content(@comment.user.nickname)
    # 詳細ページ上に先ほどのコメント内容が含まれていることを確認する(コメント文)
    expect(page).to have_content(@comment.text)
  end
  it 'ログインしていないと商品詳細ページでコメント投稿ができない' do
    # トップページに移動する
    # 商品詳細ページに遷移する
    # 商品詳細ページにコメント投稿フォームがないことを確認する
  end

end
