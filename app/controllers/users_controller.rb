class UsersController < ApplicationController

  def index 
    @s = SummitResult.ransack(params[:q])
    @summit_results = 
      if params[:q].nil? 
        SummitResult.none 
      else    
        @s.result(distinct: false)
      end

    @p = PandaResult.ransack(params[:p])
    @panda_results = 
      if params[:p].nil?
        PandaResult.none 
      else  
        @p.result(distinct: false)
      end 

    @c = CashlessResult.ransack(params[:c], search_key: :c)
    @cashless_results = 
      if params[:c].nil? 
        CashlessResult.none 
      else  
        @c.result(distinct: false)
      end 
    

  end 

  def show 
    @user = User.find(params[:id])

  end 


  private 

end
