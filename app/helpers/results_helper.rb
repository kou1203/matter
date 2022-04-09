module ResultsHelper
  # dメル,aupayメソッド
  # 新規
    def this_period(product,date)
      return product.where(date: date.minimum(:date)..date.maximum(:date))
    end

    def dmer_def(product, date)
      return product.where(status: "自社不備")
      .or(product.where(status: "審査NG"))
      .or(product.where(status: "不備対応中"))
      .or(product.where(status: "申込取消"))
      .or(product.where(status: "申込取消（不備）"))
      # .or(product.where(status: "審査OK")
      # .where.not(result_point: date.minimum(:date)..date.maximum(:date).end_of_month))
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
      return product.where(deficiency_solution: date.minimum(:date)..date.maximum(:date))
    end

    def dec_period(product,date)
      return product.where(deficiency: date.minimum(:date)..date.maximum(:date))
    end

    def share_period(product, date)
      return product.where(share: date.minimum(:date)..date.maximum(:date))
    end

  # 決済
    def slmt_this_period(product,date)
      return product
        .where(status_update_settlement: date.minimum(:date)..date.maximum(:date))
        .where(status: "審査OK")
        .where(status_settlement: "完了")
        .or(product.where(status_update_settlement: date.minimum(:date)..date.maximum(:date))
        .where(status: "審査通過")
        .where(status_settlement: "完了"))
    end

    def slmt_not_period(product,date)
      return product.where.not(settlement: date.minimum(:date)..date.maximum(:date))
    end

    def slmt_inc_period(product,date)
      return product.where(deficiency_solution_settlement: date.minimum(:date)..date.maximum(:date))
    end

    def slmt_dec_period(product,date)
      return product.where(deficiency_settlement: date.minimum(:date)..date.maximum(:date))
    end

    def slmt_def_period(product,date)
      return product.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(product.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: date.minimum(:date)..date.maximum(:date)))
    end
end
