class DefRespondingsController < ApplicationController
  before_action :authenticate_user!
  def index 
    @dmers = Dmer.includes(:store_prop, :user).where(status: "不備対応中")
    @aupays = Aupay.includes(:store_prop, :user)
      .where(status: "差し戻し").where.not(deficiency_remarks: "既存auPAY加盟店の登録がすでにあるため、差し戻しさせていただきます。")
    @rakuten_pays = RakutenPay.includes(:store_prop, :user).where(status: "自社不備")
  end 
end
