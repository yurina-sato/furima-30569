
## usersテーブル(devise)
| Column     | Type   | Options     |
| ---------- | ------ | ----------- |
| email      | string | null: false |
| password   | string | null: false |
| name       | string | null: false |

### Association
- has_many :items
- has_many :orders
- has_one :profile


## profilesテーブル
| Column           | Type       | Options                        |
| ---------------- | ---------- | ------------------------------ |
| first_name       | string     | null: false                    |
| last_name        | string     | null: false                    |
| first_name_kana  | string     | null: false                    |
| last_name_kana   | string     | null: false                    |
| birth_date_year  | integer    | null: false                    |
| birth_date_month | integer    | null: false                    |
| birth_date_day   | integer    | null: false                    |
| user             | references | null: false, foreign_key: true |

### Association
- belongs_to :user


## itemsテーブル
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| item_name          | string     | null: false                    |
| item_text          | text       | null: false                    |
| price              | integer    | null: false                    |
| status_id          | integer    | null: false                    |
| category_id        | integer    | null: false                    |
| prefecture_id      | integer    | null: false                    |
| day_id             | integer    | null: false                    |
| delivery_charge_id | integer    | null: false                    |
| user               | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- has_one_attached :image
- belongs_to_active_hash :status
- belongs_to_active_hash :category
- belongs_to_active_hash :prefecture
- belongs_to_active_hash :day
- belongs_to_active_hash :delivery_charge_id


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

