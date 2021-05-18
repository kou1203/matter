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
| suitable_time    | string      | null: false |
| description      | text        | None        |
| industry         | string      | null: false |
| phone_number_1   | string      | None        |
| phone_number_2   | string      | None        |
| person           | string      | null: false |
| prefectures      | string      | null: false |
| city             | string      | null: false |
| municipalities   | string      | null: false |
| address          | string      | null: false |
| building_name    | string      | None        |

### Association
- has_one dmer
- belongs_to au
- belongs_to paypay
- belongs_to rakuten
- belongs_to stock
- has_one praness



## dmerテーブル

 | columns               | type       | option      |
 | --------------------- | ---------- | ----------- |
 | store_prop_id         | references | null: false |
 | user_id               | references | null: false |
 | in_charge             | string     | null: false |
 | visit_status          | string     | null: false |
 | get_date              | integer    | null: false |
 | mail                  | string     | null: false |
 | description           | text       | None        |
 | payment               | integer    | None        |
 | settlement_payment    | integer    | None        |
 | picture_payment       | integer    | None        |

 ### Association
- belongs_to store_prop
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

## stock 

| columns         | type        | option      |
| --------------- | ----------- | ----------- |
| stock_num       | string      | null: false |
| mac_num         | string      | null: false |
| status          | string      | None        |
| mail            | string      | null: false |
| put_date        | date        | null:false  |
| remarks         | text        | None        |

### Association
belongs_to user
has_one praness

## stock_history
| columns         | type        | option      |
| --------------- | ----------- | ----------- |
| user            | references  |             |
| stock           | references  |             |
| take_out        | date        |             |
| return          | date        |             |

## praness 

| columns         | type        | option      |
| --------------- | ----------- | ----------- |
| user_id         | references  | null:false  |
| store_prop_id   | references  | null:false  |
| stock_id        | references  | null:false  |
| get_date        | date        | null: false |
| ssid_change     | date        | None        |
| ssid_1          | string      | null: false |
| ssid_2          | string      | null: false |
| pass_1          | string      | null: false |
| pass_2          | string      | null: false |
| cancel          | date        | None        |
| return_remarks  | string      | None        |
| remarks         | text        | None        |
| claim           | number      | null: false |
| start           | date        | null: false |
| deadline        | date        | null: false |
| withdrawal      | date        | null: false |
| payment         | date        | null: false |

### Association
belongs_to user
belongs_to :store_prop
belongs_to stock

# Panda

| columns         | type        | option      |
| --------------- | ----------- | ----------- |
| customer_num    | string      | None        |
| get_date        | date        | null: false |
| user_id         | references  | null: false |
| store_prop_id   | references  | null: false |
| food_category   | string      | null: false |
| mail            | string      | null: false |
| grid_id         | string      | None        |
| ghost_flag      | string      | None        |
| status          | string      | null: false |
| before_status   | string      | null: false |
| image_status    | string      | null: false |
| client          | string      | null: false |
| menu_create     | string      | None        |
| docu_sign_send  | date        | None        |
| docu_sign_done  | date        | None        |
| confirmer       | string      | None        |
| solution_date   | date        | None        |
| remarks         | text        | None        |
| training_date   | date        | None        |
| confirm_date    | date        | None        |





### /案件管理

## 利益表