class OrderAddress
  include ActiveModel::Model
  attr_accessor :postal_cord, :prefecture_id, :city, :house_number, :building, :phone_number, :item_id, :user_id, :price, :token

  # Addressモデルのバリデーション
  with_options presence: true do
    validates :postal_cord, format: { with: /\A\d{3}[-]\d{4}\z/, message: 'はハイフンを入れて正しく入力してください' } # 郵便番号の正規表現(3桁-4桁)
    validates :prefecture_id, numericality: { other_than: 0, message: 'を選択してください' }
    validates :city, :house_number, :token, :item_id, :user_id
    validates :phone_number, numericality: { with: /\A\d{10,11}\z/, message: 'は半角数字で入力してください' } # 電話番号(半角・ハイフンなし)
  end
  validates :phone_number, length: {maximum: 11, message: 'は11桁以内で入力してください'} # 電話番号(11桁以内)

  def save
    order = Order.create(item_id: item_id, user_id: user_id)
    Address.create(postal_cord: postal_cord, prefecture_id: prefecture_id, city: city, house_number: house_number, building: building, phone_number: phone_number, order_id: order.id)
  end
end
