class AddProfitToResults < ActiveRecord::Migration[6.1]
  def change
    add_column :results, :profit, :integer
    add_column :results, :first_total_visit, :integer
    add_column :results, :latter_total_visit, :integer
    add_column :results, :visit10, :integer
    add_column :results, :visit11, :integer
    add_column :results, :visit12, :integer
    add_column :results, :visit13, :integer
    add_column :results, :visit14, :integer
    add_column :results, :visit15, :integer
    add_column :results, :visit16, :integer
    add_column :results, :visit17, :integer
    add_column :results, :visit18, :integer
    add_column :results, :visit19, :integer
    add_column :results, :visit20, :integer
    add_column :results, :get10, :integer
    add_column :results, :get11, :integer
    add_column :results, :get12, :integer
    add_column :results, :get13, :integer
    add_column :results, :get14, :integer
    add_column :results, :get15, :integer
    add_column :results, :get16, :integer
    add_column :results, :get17, :integer
    add_column :results, :get18, :integer
    add_column :results, :get19, :integer
    add_column :results, :get20, :integer
    # サミットの基準値
    add_column :results, :first_full_talk2, :integer
    add_column :results, :latter_full_talk2, :integer
    add_column :results, :revisit_full_talk, :integer
    add_column :results, :revisit_get, :integer
    add_column :results, :product, :string
    # 帯同時間、備考 
    add_column :results, :ojt_start, :time
    add_column :results, :ojt_end, :time
    add_column :results, :remarks, :text
  end
end
