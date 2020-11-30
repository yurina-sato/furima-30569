require 'rails_helper'

def basic_pass(path) # basic認証
  username = ENV['FURIMA_BASIC_AUTH_USER']
  password = ENV['FURIMA_BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe "お気に入り登録", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
  end

  it 'ログインしたユーザーは商品詳細ページでお気に入り登録ができる' do
    # ログインする
    basic_pass new_user_session_path
    fill_in 'メールアドレス', with: @user.email
    fill_in 'パスワード', with: @user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path
    # 商品詳細ページに遷移する
    visit item_path(@item.id)
    # 詳細ページ上にお気に入り登録ボタンが存在することを確認する
    expect(page).to have_link 'お気に入り', href: item_likes_path(@item.id)
    # お気に入りボタンをクリックすると、Likeモデルのカウントが1上がることを確認する
    expect{
      find_link('お気に入り', href: item_likes_path(@item.id)).click
    }.to change { Like.count }.by(1)
    # 「お気に入りに登録しました。」の文字があることを確認する
    expect(page).to have_content('お気に入りに登録しました。')
    # 詳細ページ上にお気に入り解除ボタンが存在することを確認する
    expect(page).to have_content('お気に入りから削除')
  end

  it 'ログインしていないと商品詳細ページでお気に入り登録ができない' do
    # トップページに移動する
    basic_pass root_path
    # 商品詳細ページに遷移する
    visit item_path(@item.id)
    # 詳細ページ上にお気に入り登録ボタンが存在することを確認する
    expect(page).to have_link 'お気に入り', href: item_likes_path(@item.id)
    # お気に入りボタンをクリックする
    click_link 'お気に入り'
    # ログインページに遷移したことを確認する
    expect(current_path).to eq new_user_session_path
  end
end

RSpec.describe "お気に入り削除", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
    @like = FactoryBot.create(:like, user_id: @user.id, item_id: @item.id)
  end

  it 'ログインしたユーザーはお気に入り登録した商品の詳細ページでお気に入り削除ができる' do
    # ログインする
    basic_pass new_user_session_path
    fill_in 'メールアドレス', with: @user.email
    fill_in 'パスワード', with: @user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path
    # 商品詳細ページに遷移する
    visit item_path(@item.id)
    # 詳細ページ上にお気に入り登録ボタンが存在することを確認する
    expect(page).to have_link 'お気に入りから削除'
    # お気に入り解除ボタンをクリックすると、Likeモデルのカウントが1下がることを確認する
    expect{
      find_link('お気に入りから削除').click
    }.to change { Like.count }.by(-1)
    # 「お気に入りから削除しました。」の文字があることを確認する
    expect(page).to have_content('お気に入りから削除しました。')
    # 詳細ページ上にお気に入り登録ボタンが存在することを確認する
    expect(page).to have_content('お気に入り')
  end

  it 'ログインしていないと商品詳細ページでお気に入り削除ができない' do
    # トップページに移動する
    basic_pass root_path
    # 商品詳細ページに遷移する
    visit item_path(@item.id)
    # 詳細ページ上にお気に入り登録ボタンが存在することを確認する
    expect(page).to have_no_link 'お気に入りから削除'
  end
end