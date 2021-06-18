class PandaProfitsController < ApplicationController

  def index 
    @pandas = Panda.all
    @panda_claim_expected = Panda.where(status: "入金待ち").group("YEAR(result_point)").group("MONTH(result_point)").count
    @panda_claim = Panda.where(status: "入金済").group("YEAR(result_point)").group("MONTH(result_point)").count

    @chart = [
      {name: "入金待ち", data: @panda_claim_expected},
      {name: "入金済", data: @panda_claim}
    ]
  end 
end
