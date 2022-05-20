class SettlementsController < ApplicationController

  def index 
    # ユーザー情報
    @users_chubu = User.where(base: "中部SS").where.not(position: "退職")
    @users_kanto = User.where(base: "関東SS").where.not(position: "退職")
    @users_kansai = User.where(base: "関西SS").where.not(position: "退職")
    @stores = StoreProp.includes(:dmer, :aupay)
      .order("dmer.user_id").order("aupay.user_id").order(:id)
    # 中部
    @slmts_chubu = @stores.where(prefecture: "愛知県")
    .or(@stores.where(prefecture: "岐阜県"))
    .or(@stores.where(prefecture: "三重県"))
    .or(@stores.where(prefecture: "静岡県"))
    .or(@stores.where(prefecture: "滋賀県"))
    # 関西
    @slmts_kansai = @stores.where(prefecture: "大阪府")
    .or(@stores.where(prefecture: "京都府"))
    .or(@stores.where(prefecture: "兵庫県"))
    .or(@stores.where(prefecture: "奈良県"))
    .or(@stores.where(prefecture: "和歌山県"))
    # 関東
    @slmts_kanto = @stores.where(prefecture: "東京都")
    .or(@stores.where(prefecture: "埼玉県"))
    .or(@stores.where(prefecture: "千葉県"))
    .or(@stores.where(prefecture: "神奈川県"))
    .or(@stores.where(prefecture: "栃木県"))
  end 
end
