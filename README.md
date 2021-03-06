
## usersテーブル(devise)
| Column          | Type       | Options     |
| --------------- | ---------- | ----------- |
| email           | string     | null: false |
| password        | string     | null: false |
| nickname        | string     | null: false |
| first_name      | string     | null: false |
| last_name       | string     | null: false |
| first_name_kana | string     | null: false |
| last_name_kana  | string     | null: false |
| birth_date      | date       | null: false |

### Association
- has_many :items
- has_many :orders
- has_many :comments
- has_many :likes
- has_many :liked_items, through: :likes, source: :item


## itemsテーブル
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| name               | string     | null: false                    |
| text               | text       | null: false                    |
| price              | integer    | null: false                    |
| status_id          | integer    | null: false                    |
| category_id        | integer    | null: false                    |
| prefecture_id      | integer    | null: false                    |
| day_id             | integer    | null: false                    |
| delivery_charge_id | integer    | null: false                    |
| user               | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- has_one :order
- has_many_attached :images
- belongs_to_active_hash :status
- belongs_to_active_hash :category
- belongs_to_active_hash :prefecture
- belongs_to_active_hash :day
- belongs_to_active_hash :delivery_charge
- has_many :comments, dependent: :destroy
- has_many :likes, dependent: :destroy
- has_many :liked_users, through: :likes, source: :user

## ordersテーブル
| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| item   | references | null: false, foreign_key: true |
| user   | references | null: false, foreign_key: true |

### Association
- belongs_to :item
- belongs_to :user
- has_one :address


## addressesテーブル
| Column        | Type       | Options                        |
| ------------- | ---------- | ------------------------------ |
| postal_cord   | string     | null: false                    |
| prefecture_id | integer    | null: false                    |
| city          | string     | null: false                    |
| house_number  | string     | null: false                    |
| building      | string     |                                |
| phone_number  | string     | null: false                    |
| order         | references | null: false, foreign_key: true |

### Association
- belongs_to :order
- belongs_to_active_hash :prefecture


## 【追加実装】 commentsテーブル
| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| text   | text       | null: false                    |
| item   | references | null: false, foreign_key: true |
| user   | references | null: false, foreign_key: true |

### Association
- belongs_to :item
- belongs_to :user


## 【追加実装】 likesテーブル
| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| item   | references | null: false, foreign_key: true |
| user   | references | null: false, foreign_key: true |

### Association
- belongs_to :item
- belongs_to :user
- validates_uniqueness_of :item_id, scope: :user_id