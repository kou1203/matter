class OtherProduct < ApplicationRecord
  belongs_to :user

  with_options presence: true do 
    validates :user_id 
    validates :product_name
    validates :product_len
    validates :date
    validates :profit
    validates :valuation
  end 

  def aupay_pic_valuation
    product_len * 1500
  end
  def aupay_pic_profit
    product_len * 2500
  end
  def set_aupay_pic_params
    {:profit => aupay_pic_profit, :valuation => aupay_pic_valuation}
  end

  def dmer_pic_valuation
    product_len * 2000
  end
  def dmer_pic_profit
    product_len * 3000
  end
  def set_dmer_pic_params
    {:profit => dmer_pic_profit, :valuation => dmer_pic_valuation}
  end

  def airpay_pic_valuation
    product_len * 1500
  end
  def airpay_pic_profit
    product_len * 10000
  end
  def set_airpay_pic_params
    {:profit => airpay_pic_profit, :valuation => airpay_pic_valuation}
  end
end
