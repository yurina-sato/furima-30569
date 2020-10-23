class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :items
  has_many :orders
  has_many :comments
  has_many :likes

  with_options presence: true do
    validates :nickname, :birth_date

    # validates :email, uniqueness: { message: 'はすでに存在します' } # emailの一意性

    PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze # 英数混合の正規表現
    validates :password, format: { with: PASSWORD_REGEX, message: 'は英字と数字を両方含んでください' }

    FULL_WIDTH_KANA = /\A[ぁ-んァ-ン一-龥]/.freeze # 全角かな・漢字・カタカナの正規表現
    validates :first_name, :last_name, format: { with: FULL_WIDTH_KANA, message: 'は全角(漢字・かな・カナ)で入力してください' }

    FULL_WIDTH_KATAKANA =  /\A[ァ-ヶー－]+\z/.freeze # 全角カタカナの正規表現
    validates :first_name_kana, :last_name_kana, format: { with: FULL_WIDTH_KATAKANA, message: 'は全角(カナ)で入力してください' }
  end

  def already_liked?(item) # ユーザーが商品に対して、すでにお気に入り登録をしているのかどうかを判定
    self.likes.exists?(item_id: item.id)
  end
end
