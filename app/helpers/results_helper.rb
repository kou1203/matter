module ResultsHelper
  # dメル,aupayメソッド
  # 新規
    def this_period(product,date)
      return product.where(date: date.minimum(:date)..date.maximum(:date))
    end


    def judge_inc(product, date)
      return product.where.not(date: date.minimum(:date)..date.maximum(:date))
        .where(status: "審査通過")
        .where(result_point: date.maximum(:date).beginning_of_month..date.maximum(:date).end_of_month)
        .or(product.where.not(date: date.minimum(:date)..date.maximum(:date))
        .where(status: "審査OK").where(result_point: date.maximum(:date).beginning_of_month..date.maximum(:date).end_of_month))
    end

    def judge_dec(product, date)
      return product.where(date: date.minimum(:date)..date.maximum(:date))
        .where(status: "審査通過")
        .where.not(result_point: date.maximum(:date).beginning_of_month..date.maximum(:date).end_of_month)
        .or(product.where(date: date.minimum(:date)..date.maximum(:date))
        .where(status: "審査OK")
        .where.not(result_point: date.maximum(:date).beginning_of_month..date.maximum(:date).end_of_month))
    end

    def dmer_def(product, date)
      return product.where(status: "自社不備")
        .or(product.where(status: "審査NG"))
        .or(product.where(status: "不備対応中"))
        .or(product.where(status: "申込取消"))
        .or(product.where(status: "申込取消（不備）"))
        .or(product.where(status: "社内確認中"))
        .or(product.where(industry_status: "NG"))
        .or(product.where(industry_status: "×"))
        .or(product.where(industry_status: "要確認"))
        # .where(result_point: date.minimum(:date)..date.maximum(:date).end_of_month))
    end

    def aupay_def(product, date)
      return product.where(status: "自社不備")
      .or(product.where(status: "不合格"))
      .or(product.where(status: "差し戻し"))
      .or(product.where(status: "解約"))
      .or(product.where(status: "報酬対象外"))
      .or(product.where(status: "重複対象外"))
      # .or(product.where(status: "審査通過")
      # .where.not(result_point: date.minimum(:date)..date.maximum(:date).end_of_month))
    end

    def rakuten_inc(product, date)
      return product
        .where.not(date: date.minimum(:date)..date.maximum(:date))
        .where(share: date.minimum(:date)..date.maximum(:date))
        .where.not(deficiency: nil)
    end 

    def inc_period(product,date)
      return product.where(result_point: date.minimum(:date)..date.maximum(:date))
    end

    def dec_period(product,date)
      return product.where(deficiency: date.minimum(:date)..date.maximum(:date))
    end

    def result_period(product, date)
      return product
        .where(result_point: date.maximum(:date).beginning_of_month...date.maximum(:date).end_of_month)
    end

    def share_period(product, date)
      return product
        .where(share: date.minimum(:date)...date.maximum(:date))
    end

  # 決済
    def slmt_period(product, date)
      return product
      .where(picture: date.minimum(:date)..date.maximum(:date))
      .where.not(status: "不備対応中")
      .where.not(status: "審査NG")
      .where.not(status: "申込取消")
      .where.not(status: "申込取消（不備）")
      .where.not(status: "不合格")
      .where.not(status: "報酬対象外")
      .where.not(status: "重複対象外")
      .where.not(status: "差し戻し")
      .where.not(status: "解約")
      .where(status_settlement: "完了")
    end 

    def slmt_this_period(product,date)
      return product
        .where("result_point < ?", date.maximum(:date).end_of_month)
        .where(status_update_settlement: date.maximum(:date).beginning_of_month..date.maximum(:date).end_of_month)
        .where.not(status: "不備対応中")
        .where.not(status: "審査NG")
        .where.not(status: "申込取消")
        .where.not(status: "申込取消（不備）")
        .where.not(status: "不合格")
        .where.not(status: "報酬対象外")
        .where.not(status: "重複対象外")
        .where.not(status: "差し戻し")
        .where.not(status: "解約")
        .where(status_settlement: "完了")
        .or(
          product.where("status_update_settlement < ?", date.maximum(:date).beginning_of_month)
          .where.not(status: "不備対応中")
          .where.not(status: "審査NG")
          .where.not(status: "申込取消")
          .where.not(status: "申込取消（不備）")
          .where(status_settlement: "完了")
          .where.not(status: "不合格")
          .where.not(status: "報酬対象外")
          .where.not(status: "重複対象外")
          .where.not(status: "差し戻し")
          .where.not(status: "解約")
          .where(status_settlement: "完了")
          .where(result_point: date.maximum(:date).beginning_of_month..date.maximum(:date).end_of_month)
        )
        .or(
          product.where(result_point: nil)
          .where(status_update_settlement: date.maximum(:date).beginning_of_month..date.maximum(:date).end_of_month)
          .where.not(status: "不備対応中")
          .where.not(status: "審査NG")
          .where.not(status: "申込取消")
          .where.not(status: "申込取消（不備）")
          .where(status_settlement: "完了")
          .where.not(status: "不合格")
          .where.not(status: "報酬対象外")
          .where.not(status: "重複対象外")
          .where.not(status: "差し戻し")
          .where.not(status: "解約")
          .where(status_settlement: "完了")
        )
    end

    def slmt_inc(product,date)
      return product.where(status_settlement: "完了")
        .where(status_update_settlement: date.maximum(:date).beginning_of_month..date.maximum(:date).end_of_month)
        .where.not(settlement: date.minimum(:date)..date.maximum(:date))
    end

    def slmt_second(product,date)
      return product.where(status: "審査OK")
        .where(status_settlement: "完了")
        .where(settlement_second: date.minimum(:date)..date.maximum(:date))
    end 

    def slmt_quick(product, date)
      return product.where(client: "マックス即時")
        .where(settlement: date.minimum(:date)..date.maximum(:date))
    end


    def slmt_dead_line(product,date)
      return product.where(settlement_deadline: date.minimum(:date)..date.maximum(:date).since(3.month).end_of_month).where(status: "審査OK").where(settlement: nil)
      .or(product.where(settlement_deadline: date.minimum(:date)..date.maximum(:date).since(3.month).end_of_month).where(status: "審査OK").where(settlement: date.minimum(:date)..date.maximum(:date)))
      .or(product.where(settlement_deadline: date.minimum(:date)..date.maximum(:date).since(3.month).end_of_month).where(status: "審査通過").where(settlement: nil))
      .or(product.where(settlement_deadline: date.minimum(:date)..date.maximum(:date).since(3.month).end_of_month).where(status: "審査通過").where(settlement: date.minimum(:date)..date.maximum(:date)))
    end


    def slmt2nd_dead_line(product,date)
      return product.where(client: "ピアズ")
        .where(settlement_deadline: date.minimum(:date)
        .prev_month..date.maximum(:date).since(3.month).end_of_month)
        .where.not(industry_status: "×").where.not(industry_status: "NG").where(status: "審査OK")
        .where(settlement: Date.new(2021-12-01)..date.maximum(:date).prev_month.end_of_month)
        .where(settlement_second: date.minimum(:date)..date.maximum(:date))
        .or(product.where(client: "ピアズ")
        .where(settlement_deadline: date.minimum(:date).prev_month..date.maximum(:date).since(3.month).end_of_month)
        .where.not(industry_status: "×").where.not(industry_status: "NG").where(status: "審査OK")
        .where(settlement: Date.new(2021-12-01)..date.maximum(:date)
        .prev_month.end_of_month).where(settlement_second: nil))
        .or(product.where(client: "マックス即時（d）")
        .where(status_settlement: "完了").where.not(industry_status: "×").where.not(industry_status: "NG").where(status: "審査OK")
        .where(settlement_second: nil))
        .or(product.where(client: "マックス即時（d）")
        .where(status_settlement: "完了").where.not(industry_status: "×").where.not(industry_status: "NG").where(status: "審査OK")
        .where(settlement_second: date.minimum(:date)..date.maximum(:date)))
    end

end
