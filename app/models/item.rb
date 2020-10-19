class Item < ApplicationRecord
  belongs_to :user
  has_one :order
  has_many_attached :images

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :status
  belongs_to_active_hash :category
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :day
  belongs_to_active_hash :delivery_charge

  validates :price, numericality: { with: /\A[0-9]+\z/, message: 'は半角数字で入力してください' } # 半角数字の正規表現

  with_options presence: true do
    validates :images, :name, :text

    validates :price, numericality: { greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999, message: 'は範囲内の金額で設定してください' }

    validates :status_id, :category_id, :prefecture_id, :day_id, :delivery_charge_id,
              numericality: { other_than: 0, message: 'を選択してください' }
  end
end
