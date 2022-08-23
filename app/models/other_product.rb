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
end
