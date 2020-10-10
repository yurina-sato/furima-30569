class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :items
  has_many :orders

  with_options presence: true do
    validates :nickname, :birth_date

    validates :email, uniqueness: { message: "has already been taken" } #emailの一意性
    PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze #英数混合の正規表現
    validates :password, format: { with: PASSWORD_REGEX, message: "Include both letters and numbers" }
    validates :first_name, format: { with: /\A[ぁ-んァ-ン一-龥]/, message: "Full-width characters"}
    validates :last_name, format: { with: /\A[ぁ-んァ-ン一-龥]/, message: "Full-width characters"}
    validates :first_name_kana, format: { with: /\A[ァ-ヶー－]+\z/, message: "Full-width katakana characters"}
    validates :last_name_kana, format: { with: /\A[ァ-ヶー－]+\z/, message: "Full-width katakana characters"}
  end
  
end

