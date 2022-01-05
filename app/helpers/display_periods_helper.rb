module DisplayPeriodsHelper

  def this_period(product, start_date, end_date)
    return product.where(date: start_date..end_date)
  end

  def cash_valuation(product, start_date, end_date)
    return product.where(date: start_date..end_date).sum(:valuation_new) 
    - product.where.not(deficiency: nil).where(deficiency_solution: nil).or(product.where.not(deficiency: nil).where.not(deficiency_solution: start_date..end_date)).sum(:valuation_new)  
    + product.where.not(date: start_date..end_date).where(deficiency_solution: start_date..end_date).sum(:valuation_new )
    - product.where.not(date: start_date..end_date).where(deficiency: start_date..end_date).sum(:valuation_new) 
  end 
  
  def cash_profit(product, start_date, end_date)
    return product.where(date: start_date..end_date).sum(:profit_new) 
    - product.where.not(deficiency: nil).where(deficiency_solution: nil).or(product.where.not(deficiency: nil).where.not(deficiency_solution: start_date..end_date)).sum(:profit_new)  
    + product.where.not(date: start_date..end_date).where(deficiency_solution: start_date..end_date).sum(:profit_new)
    - product.where.not(date: start_date..end_date).where(deficiency: start_date..end_date).sum(:profit_new) 
  end 

  def cash_slmt_valuation(product, start_date, end_date)
    return product.where(settlement: start_date..end_date).sum(:valuation_settlement) 
    - product.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(product.where.not(deficiency: nil).where.not(deficiency_solution_settlement: start_date..end_date)).sum(:valuation_settlement)  
    + product.where.not(date: start_date..end_date).where(deficiency_solution_settlement: start_date..end_date).sum(:valuation_settlement)
    - product.where.not(date: start_date..end_date).where(deficiency_settlement: start_date..end_date).sum(:valuation_settlement) 
  end 

  def cash_slmt_profit(product, start_date, end_date)
    return product.where(settlement: start_date..end_date).sum(:valuation_settlement) 
    - product.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(product.where.not(deficiency: nil).where.not(deficiency_solution_settlement: start_date..end_date)).sum(:valuation_settlement)  
    + product.where.not(date: start_date..end_date).where(deficiency_solution_settlement: start_date..end_date).sum(:valuation_settlement)
    - product.where.not(date: start_date..end_date).where(deficiency_settlement: start_date..end_date).sum(:valuation_settlement) 
  end 

  def product_valuation(product, start_date, end_date)
    return product.where(date: start_date..end_date).sum(:valuation) 
    - product.where.not(deficiency: nil).where(deficiency_solution: nil).or(product.where.not(deficiency: nil).where.not(deficiency_solution: start_date..end_date)).sum(:valuation)  
    + product.where.not(date: start_date..end_date).where(deficiency_solution: start_date..end_date).sum(:valuation)
    - product.where.not(date: start_date..end_date).where(deficiency: start_date..end_date).sum(:valuation) 
  end 

  def product_profit(product, start_date, end_date)
    return product.where(date: start_date..end_date).sum(:profit) 
    - product.where.not(deficiency: nil).where(deficiency_solution: nil).or(product.where.not(deficiency: nil).where.not(deficiency_solution: start_date..end_date)).sum(:profit)  
    + product.where.not(date: start_date..end_date).where(deficiency_solution: start_date..end_date).sum(:profit)
    - product.where.not(date: start_date..end_date).where(deficiency: start_date..end_date).sum(:profit) 
  end 

  def casa_valuation(product, start_date, end_date)
    return product.where(date: start_date..end_date).sum(:valuation_new) 
    # 自社不備
    - product.where.not(deficiency: nil).where(deficiency_solution: nil).or(product.where.not(deficiency: nil).where.not(deficiency_solution: start_date..end_date)).sum(:valuation_new)  
    + product.where.not(date: start_date..end_date).where(deficiency_solution: start_date..end_date).sum(:valuation_new)
    - product.where.not(date: start_date..end_date).where(deficiency: start_date..end_date).sum(:valuation_new)
    # 回線不備
    - product.where.not(deficiency_net: nil).where(deficiency_solution_net: nil).or(product.where.not(deficiency_net: nil).where.not(deficiency_solution_net: start_date..end_date)).sum(:valuation_new)  
    + product.where.not(date: start_date..end_date).where(deficiency_solution_net: start_date..end_date).sum(:valuation_new)
    - product.where.not(date: start_date..end_date).where(deficiency_net: start_date..end_date).sum(:valuation_new)
    # 反社不備
    - product.where.not(deficiency_anti: nil).where(deficiency_solution_anti: nil).or(product.where.not(deficiency_anti: nil).where.not(deficiency_solution_anti: start_date..end_date)).sum(:valuation_new)  
    + product.where.not(date: start_date..end_date).where(deficiency_solution_anti: start_date..end_date).sum(:valuation_new)
    - product.where.not(date: start_date..end_date).where(deficiency_anti: start_date..end_date).sum(:valuation_new)
  end
  def casa_profit(product, start_date, end_date)
    return product.where(date: start_date..end_date).sum(:profit_new) 
    # 自社不備
    - product.where.not(deficiency: nil).where(deficiency_solution: nil).or(product.where.not(deficiency: nil).where.not(deficiency_solution: start_date..end_date)).sum(:profit_new)  
    + product.where.not(date: start_date..end_date).where(deficiency_solution: start_date..end_date).sum(:profit_new)
    - product.where.not(date: start_date..end_date).where(deficiency: start_date..end_date).sum(:profit_new)
    # 回線不備
    - product.where.not(deficiency_net: nil).where(deficiency_solution_net: nil).or(product.where.not(deficiency_net: nil).where.not(deficiency_solution_net: start_date..end_date)).sum(:profit_new)  
    + product.where.not(date: start_date..end_date).where(deficiency_solution_net: start_date..end_date).sum(:profit_new)
    - product.where.not(date: start_date..end_date).where(deficiency_net: start_date..end_date).sum(:profit_new)
    # 反社不備
    - product.where.not(deficiency_anti: nil).where(deficiency_solution_anti: nil).or(product.where.not(deficiency_anti: nil).where.not(deficiency_solution_anti: start_date..end_date)).sum(:profit_new)  
    + product.where.not(date: start_date..end_date).where(deficiency_solution_anti: start_date..end_date).sum(:profit_new)
    - product.where.not(date: start_date..end_date).where(deficiency_anti: start_date..end_date).sum(:profit_new)
  end

  def casa_put_valuation(product, start_date, end_date)
    product.where(put: start_date..end_date).sum(:valuation_put)
  end
  
  def casa_put_profit(product, start_date, end_date)
    product.where(put: start_date..end_date).sum(:profit_put)
  end
end
