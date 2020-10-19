require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー新規登録' do
    before do
      @user = FactoryBot.build(:user)
    end

    context '新規登録がうまくいくとき' do
      it 'nickname, email, password, password_confirmation, first_name, last_name, first_name_kana, last_name_kana, birth_dateが存在すれば登録できる' do
        expect(@user).to be_valid
      end
      it 'emailが＠を含めば登録できる' do
        @user.email = 'sample@sample.com'
        expect(@user).to be_valid
      end
      it 'passwordが英数混合の6文字以上であれば登録できる' do
        @user.password = '123abc'
        @user.password_confirmation = '123abc'
        expect(@user).to be_valid
      end
      it 'first_nameが全角（漢字・ひらがな・カタカナ）であれば登録できる' do
        @user.first_name = '佐藤'
        expect(@user).to be_valid
      end
      it 'last_nameが全角（漢字・ひらがな・カタカナ）であれば登録できる' do
        @user.last_name = '太郎'
        expect(@user).to be_valid
      end
      it 'first_name_kanaが全角（カタカナ）であれば登録できる' do
        @user.first_name_kana = 'サトウ'
        expect(@user).to be_valid
      end
      it 'last_name_kanaが全角（カタカナ）であれば登録できる' do
        @user.last_name_kana = 'タロウ'
        expect(@user).to be_valid
      end
    end

    context '新規登録がうまくいかないとき' do
      it 'nicknameが空だと登録できない' do
        @user.nickname = nil
        @user.valid?
        expect(@user.errors.full_messages).to include('ニックネームを入力してください')
      end
      it 'emailが空だと登録できない' do
        @user.email = nil
        @user.valid?
        expect(@user.errors.full_messages).to include('Eメールを入力してください')
      end
      it '重複したemailが存在する場合は登録できない' do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Eメールはすでに存在します')
      end
      it 'emailが@を含まない場合は登録できない' do
        @user.email = 'sample.com'
        @user.valid?
        expect(@user.errors.full_messages).to include('Eメールは不正な値です')
      end
      it 'passwordが空だと登録できない' do
        @user.password = nil
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードを入力してください')
      end
      it 'passwordが英数混合でも5文字以下では登録できない' do
        @user.password = '123ab'
        @user.password_confirmation = '123ab'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは6文字以上で入力してください')
      end
      it 'passwordが半角数字のみでは登録できない' do
        @user.password = '123456'
        @user.password_confirmation = '123456'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは英字と数字を両方含んでください')
      end
      it 'passwordが半角英字のみでは登録できない' do
        @user.password = 'abcdef'
        @user.password_confirmation = 'abcdef'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは英字と数字を両方含んでください')
      end
      it 'passwordが存在してもpassword_confirmationが空では登録できない' do
        @user.password_confirmation = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end
      it 'first_nameが空だと登録できない' do
        @user.first_name = nil
        @user.valid?
        expect(@user.errors.full_messages).to include('名字を入力してください')
      end
      it 'first_nameが半角英字では登録できない' do
        @user.first_name = 'abe'
        @user.valid?
        expect(@user.errors.full_messages).to include('名字は全角(漢字・かな・カナ)で入力してください')
      end
      it 'first_nameが半角カタカナでは登録できない' do
        @user.first_name = 'ｱﾍﾞ'
        @user.valid?
        expect(@user.errors.full_messages).to include('名字は全角(漢字・かな・カナ)で入力してください')
      end
      it 'last_nameが空だと登録できない' do
        @user.last_name = nil
        @user.valid?
        expect(@user.errors.full_messages).to include('名前を入力してください')
      end
      it 'last_nameが半角英字では登録できない' do
        @user.last_name = 'hoge'
        @user.valid?
        expect(@user.errors.full_messages).to include('名前は全角(漢字・かな・カナ)で入力してください')
      end
      it 'last_nameが半角カタカナでは登録できない' do
        @user.last_name = 'ﾎｹﾞ'
        @user.valid?
        expect(@user.errors.full_messages).to include('名前は全角(漢字・かな・カナ)で入力してください')
      end
      it 'first_name_kanaが空だと登録できない' do
        @user.first_name_kana = nil
        @user.valid?
        expect(@user.errors.full_messages).to include('名字(フリガナ)を入力してください')
      end
      it 'first_name_kanaが半角英字では登録できない' do
        @user.first_name_kana = 'fuga'
        @user.valid?
        expect(@user.errors.full_messages).to include('名字(フリガナ)は全角(カナ)で入力してください')
      end
      it 'first_name_kanaが全角（漢字・ひらがな）では登録できない' do
        @user.first_name_kana = 'ふが'
        @user.valid?
        expect(@user.errors.full_messages).to include('名字(フリガナ)は全角(カナ)で入力してください')
      end
      it 'first_name_kanaが半角カタカナでは登録できない' do
        @user.first_name_kana = 'ﾌｶﾞ'
        @user.valid?
        expect(@user.errors.full_messages).to include('名字(フリガナ)は全角(カナ)で入力してください')
      end
      it 'last_name_kanaが空だと登録できない' do
        @user.last_name_kana = nil
        @user.valid?
        expect(@user.errors.full_messages).to include('名前(フリガナ)を入力してください')
      end
      it 'last_name_kanaが半角英字では登録できない' do
        @user.last_name_kana = 'piyo'
        @user.valid?
        expect(@user.errors.full_messages).to include('名前(フリガナ)は全角(カナ)で入力してください')
      end
      it 'last_name_kanaが全角（漢字・ひらがな）では登録できない' do
        @user.last_name_kana = 'ぴよ'
        @user.valid?
        expect(@user.errors.full_messages).to include('名前(フリガナ)は全角(カナ)で入力してください')
      end
      it 'last_name_kanaが半角カタカナでは登録できない' do
        @user.last_name_kana = 'ﾋﾟﾖ'
        @user.valid?
        expect(@user.errors.full_messages).to include('名前(フリガナ)は全角(カナ)で入力してください')
      end
      it 'birth_dateが空だと登録できない' do
        @user.birth_date = nil
        @user.valid?
        expect(@user.errors.full_messages).to include('生年月日を入力してください')
      end
    end
  end
end
