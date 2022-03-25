require "csv"

CSV.foreach('db/seeds//product_checker.csv', headers: true) do |row|
  ProductChecker.create(
    store_name: row['店舗名'],
    tel1: row['店舗電話番号'],
    tel2: row['担当電話番号'],
    mail1: row['メールアドレス1'],
    mail2: row['メールアドレス2'],
    mail3: row['メールアドレス3'],
    product1: row['N_P'],
    product2: row['PayPay'],
    product3: row['楽天Pay'],
    product4: row['auPay'] ,
    product5: row['メルペイ'],
    product6: row['クラウド'],
    product7: row['dメル'],
    # :product8
    # :product9
    # :product10
  )
end