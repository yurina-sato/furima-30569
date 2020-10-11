class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :items
  has_many :orders

  with_options presence: true do
    validates :nickname, :birth_date

    validates :email, uniqueness: { message: 'has already been taken' } # emailの一意性
    
    PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze # 英数混合の正規表現
    validates :password, format: { with: PASSWORD_REGEX, message: 'Include both letters and numbers' }

    FULL_WIDTH_KANA = /\A[ぁ-んァ-ン一-龥]/ # 全角かな・漢字・カタカナの正規表現
    validates :first_name, :last_name, format: { with: FULL_WIDTH_KANA, message: 'Full-width characters' }
    
    FULL_WIDTH_KATAKANA =  /\A[ァ-ヶー－]+\z/ # 全角カタカナの正規表現
    validates :first_name_kana, :last_name_kana, format: { with: FULL_WIDTH_KATAKANA, message: 'Full-width katakana characters' }
  end
end


