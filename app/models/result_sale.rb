class ResultSale < ApplicationRecord

  belongs_to :user
  
  with_options presence: true do
    validates :user_id
    validates :year
    validates :month
    validates :valuation
    validates :profit
  end


  def self.import(file)
    cnt = 0
    error_cnt = 0
    no_cnt = 0
    error_name = []
    CSV.foreach(file.path, headers: true) do |row|
      if User.find_by(name: row["ユーザー名"]).nil?
        u_id = nil
        error_name << row["ユーザー名"]
      else
        u_id = User.find_by(name: row["ユーザー名"]).id
      end
      if u_id.nil?
        error_cnt += 1
      else
        result = ResultSale.find_by(user_id: u_id, year: row["年"], month: row["月"])
        if result.nil?
          r_sale = new(
            user_id: u_id                ,
            year: row["年"]              ,
            month: row["月"]             ,
            valuation: row["評価売"]     ,
            profit: row["実売"]          ,
            product: row["担当商材"]     
          )
          r_sale.save!
        end
        cnt += 1
      end
    end
    "登録#{cnt}件,エラー#{error_cnt}件#{error_name}"
  end
end
