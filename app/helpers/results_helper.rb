module ResultsHelper
    # dメル,aupayメソッド
    # 新規
    def this_period(product,date)
      return product.where(date: date.minimum(:date)..date.maximum(:date))
    end
    def not_period(product,date)
      return product.where.not(date: date.minimum(:date)..date.maximum(:date))
    end
    def inc_period(product,date)
      return product.where(deficiency_solution: date.minimum(:date)..date.maximum(:date))
    end
    def dec_period(product,date)
      return product.where(deficiency: date.minimum(:date)..date.maximum(:date))
    end
    def def_period(product,date)
      return product.where.not(deficiency: nil).where(deficiency_solution: nil).or(product.where.not(deficiency: nil).where.not(deficiency_solution: date.minimum(:date)..date.maximum(:date)))
    end
    # 決済
    def slmt_this_period(product,date)
      return product.where(settlement: date.minimum(:date)..date.maximum(:date))
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
