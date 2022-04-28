class DefRespondingsController < ApplicationController
  before_action :authenticate_user!
  def index 
    @dmers = Dmer.includes(:store_prop, :user).where(status: "不備対応中")
    @dmers_chubu = @dmers.where(user: {base: "中部SS"})
    @dmers_kansai = @dmers.where(user: {base: "関西SS"})
    @dmers_kanto = @dmers.where(user: {base: "関東SS"})

    @aupays = Aupay.includes(:store_prop, :user)
      .where(status: "差し戻し").where.not(deficiency_remarks: "既存auPAY加盟店の登録がすでにあるため、差し戻しさせていただきます。")
    @aupays_chubu = @aupays.where(user: {base: "中部SS"})
    @aupays_kansai = @aupays.where(user: {base: "関西SS"})
    @aupays_kanto = @aupays.where(user: {base: "関東SS"})

    @rakuten_pays = RakutenPay.includes(:store_prop, :user).where(status: "自社不備")
    @rakuten_pays_chubu = @rakuten_pays.where(user: {base: "中部SS"})
    @rakuten_pays_kansai = @rakuten_pays.where(user: {base: "関西SS"})
    @rakuten_pays_kanto = @rakuten_pays.where(user: {base: "関東SS"})
  end 
end
