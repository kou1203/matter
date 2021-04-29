# DATSBASE

# MATTER MODEL

### 案件管理

## userテーブル

| columns  | type   | option      |
| -------- | ------ | ----------- |
| name     | string | null: false |
| password |        |             |
| email    |        |             |

### Association
- has_many dmers
- has_many aus
- has_many paypaies
- has_many rakutens
- has_many stockes

## store_propテーブル

| columns          | type        | option      |
| ---------------- | ----------- | ----------- |
| class            | string      | None        |
| name             | string      | null:false  |
| suitable_time_id | active_hash | null: false |
| description      | text        | None        |
| industry         | string      | null: false |
| phone_number     | string      | None        |
| person           | string      | null: false |
| prefectures      | string      | null: false |
| city             | string      | null: false |
| municipalities   | string      | null: false |
| address          | string      | null: false |
| building_name    | string      | None        |

### Association
- belongs_to dmer
- belongs_to au
- belongs_to paypay
- belongs_to rakuten
- belongs_to stock
- has_one suitable_time


## dmerテーブル

 | columns               | type       | option      |
 | --------------------- | ---------- | ----------- |
 | store_prop_id         | integer    | null: false |
 | in_charge_id          | integer    | null: false |
 | visit_status          | integer    | null: false |
 | user_id               | references | None        |
 | multi_store_id        | integer    | None        |
 | date                  | date       | null: false |
 | mail                  | string     | null: false |
 | description           | text       | None        |
 | payment               | date       | None        |
 | settlement_payment    | date       | None        |
 | picture_payment       | date       | None        |

 ### Association
- has_many store_props
- belongs_to in_charge
- belongs_to visit_status
- belongs_to user


 ## auテーブル

| columns         | type        | option      |
| --------------- | ----------- | ----------- |
| store_prop_id   | references  | None        |
| in_charge_id    | active_hash | null: false |
| visit_status_id | active_hash | null: false |
| user_id         | references  | null:false  |
| date            | date        | null: false |
| payment         | date        | None        |
| mail            | string      | null: false |
| description     | text        | None        |

### Association
- has_many store_props
- has_many in_charges
- has_many visit_status
- belongs_to user

## paypayテーブル

| columns         | type        | option      |
| --------------- | ----------- | ----------- |
| store_prop_id   | references  | None        |
| in_charge_id    | active_hash | null: false |
| visit_status_id | active_hash | null: false |
| user_id         | references  | null:false  |
| date            | date        | null: false |
| payment         | date        | None        |

### Association
- has_many store_props
- has_many in_charges
- has_many visit_status
- belongs_to user

## rakutenテーブル

| columns         | type        | option      |
| --------------- | ----------- | ----------- |
| store_prop_id   | references  | None        |
| in_charge_id    | active_hash | null: false |
| visit_status_id | active_hash | null: false |
| user_id         | references  | null:false  |
| date            | date        | null: false |
| payment         | date        | None        |
| mail            | string      | null: false |

### Association
- has_many store_props
- has_many in_charges
- has_many visit_status
- belongs_to user

## stock (佐藤さんに保存絶対するタイプかどうか確認する！あと備考の文字量なども！)

| columns         | type        | option      |
| --------------- | ----------- | ----------- |
| mail            | string      | null: false |
| user_id         | references  | null:false  |
| installation    | date        | null:false  |
| ssid_change     | date        | None        |
| ssid_1          | string      | null: false |
| ssid_2          | string      | null: false |
| pass_1          | string      | null: false |
| pass_2          | string      | null: false |
| cancel          | date        | None        |
| remarks         | text        | None        |
| return_remarks  | text        | None        |

### Association
belongs_to user


# Active Hash Model

## visit_status
- has_many dmers
- has_many aus
- has_many paypaies
- has_many rakutens
- has_many stockes

## suitable_time
- belongs_to store_prop

## in_charge
- has_many dmers
- has_many aus
- has_many paypaies
- has_many rakutens
- has_many stockes

### /案件管理

## 利益表