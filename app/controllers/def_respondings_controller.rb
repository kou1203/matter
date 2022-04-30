class DefRespondingsController < ApplicationController
  before_action :authenticate_user!
  def index 
    @users_chubu = User.where(base: "中部SS").where.not(position: "退職")
    @users_kanto = User.where(base: "関東SS").where.not(position: "退職")
    @users_kansai = User.where(base: "関西SS").where.not(position: "退職")

    @dmers = Dmer.includes(:store_prop, :user).where(status: "不備対応中").where(date: Date.today.ago(2.month)..Date.today)
    @dmers_chubu = @dmers.where(user: {base: "中部SS"})
    @dmers_kansai = @dmers.where(user: {base: "関西SS"})
    @dmers_kanto = @dmers.where(user: {base: "関東SS"})

    @aupays = Aupay.includes(:store_prop, :user)
      .where(status: "差し戻し").where.not(deficiency_remarks: "既存auPAY加盟店の登録がすでにあるため、差し戻しさせていただきます。").where(date: Date.today.ago(3.month)..Date.today)
    @aupays_chubu = @aupays.where(user: {base: "中部SS"})
    @aupays_kansai = @aupays.where(user: {base: "関西SS"})
    @aupays_kanto = @aupays.where(user: {base: "関東SS"})

    @rakuten_pays = RakutenPay.includes(:store_prop, :user).where(status: "自社不備")
    @rakuten_pays_chubu = @rakuten_pays.where(user: {base: "中部SS"})
    @rakuten_pays_kansai = @rakuten_pays.where(user: {base: "関西SS"})
    @rakuten_pays_kanto = @rakuten_pays.where(user: {base: "関東SS"})
  end 
end
