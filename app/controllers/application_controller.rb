class ApplicationController < ActionController::Base
   before_action :devise_permitted_parameters, if: :devise_controller?
   
  private 


    def devise_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:base,:base_sub,:team,:position, :position_sub,:group])
    end  

    # @month = params[:month] ? Time.parse(params[:month]) : Date.today
    # @calc_periods = CalcPeriod.where(sales_category: "評価売")
    # 各商材の計算期間と成約率（実売）　calc_period_and_per上の行に上記の二列を追加する
    def calc_period_and_per
      @basic_calc_data = @calc_periods.find_by(name: "各商材獲得")
      @dmer1_calc_data = @calc_periods.find_by(name: "dメル成果1")
      @dmer2_calc_data = @calc_periods.find_by(name: "dメル成果2")
      @dmer3_calc_data = @calc_periods.find_by(name: "dメル成果3")
      @aupay1_calc_data = @calc_periods.find_by(name: "auPay成果1")
      @paypay1_calc_data = @calc_periods.find_by(name: "PayPay成果1")
      @rakuten_pay1_calc_data = @calc_periods.find_by(name: "楽天ペイ成果1")
      @airpay1_calc_data = @calc_periods.find_by(name: "AirPay成果1")
      @demaekan1_calc_data = @calc_periods.find_by(name: "出前館成果1")
      @austicker1_calc_data = @calc_periods.find_by(name: "auステッカー成果1")
      @dmersticker1_calc_data = @calc_periods.find_by(name: "dメルステッカー成果1")
      # 期間
      @basic_start_date_year_and_month = @month.since(@basic_calc_data.start_date_month.month)
      if @basic_calc_data.start_date_day == 0
        @start_date = Date.new(
          @basic_start_date_year_and_month.year,
          @basic_start_date_year_and_month.month,
          @basic_start_date_year_and_month.end_of_month.day,
        )
      else
        @start_date = Date.new(
          @basic_start_date_year_and_month.year,
          @basic_start_date_year_and_month.month,
          @basic_calc_data.start_date_day,
        )

      end 

      @basic_end_date_year_and_month = @month.since(@basic_calc_data.end_date_month.month)
      if @basic_calc_data.end_date_day == 0
        @end_date = Date.new(
          @basic_end_date_year_and_month.year,
          @basic_end_date_year_and_month.month,
          @basic_end_date_year_and_month.end_of_month.day,
        )
      else
        @end_date = Date.new(
          @basic_end_date_year_and_month.year,
          @basic_end_date_year_and_month.month,
          @basic_calc_data.end_date_day,
        )

      end


      # 締め日
      @basic_closing_date_year_and_month = @month.since(@basic_calc_data.closing_date_month.month)
      if @basic_calc_data.closing_date_day == 0
        @closing_date = Date.new(
          @basic_closing_date_year_and_month.year,
          @basic_closing_date_year_and_month.month,
          @basic_closing_date_year_and_month.end_of_month.day,
        )
      else
        @closing_date = Date.new(
          @basic_closing_date_year_and_month.year,
          @basic_closing_date_year_and_month.month,
          @basic_calc_data.closing_date_day,
        )

      end
      # 期間
      @dmer1_start_date_year_and_month = @month.since(@dmer1_calc_data.start_date_month.month)
      if @dmer1_calc_data.start_date_day == 0
        @dmer1_start_date = Date.new(
          @dmer1_start_date_year_and_month.year,
          @dmer1_start_date_year_and_month.month,
          @dmer1_start_date_year_and_month.end_of_month.day,
        )
      else
        @dmer1_start_date = Date.new(
          @dmer1_start_date_year_and_month.year,
          @dmer1_start_date_year_and_month.month,
          @dmer1_calc_data.start_date_day,
        )

      end 

      @dmer1_end_date_year_and_month = @month.since(@dmer1_calc_data.end_date_month.month)
      if @dmer1_calc_data.end_date_day == 0
        @dmer1_end_date = Date.new(
          @dmer1_end_date_year_and_month.year,
          @dmer1_end_date_year_and_month.month,
          @dmer1_end_date_year_and_month.end_of_month.day,
        )
      else
        @dmer1_end_date = Date.new(
          @dmer1_end_date_year_and_month.year,
          @dmer1_end_date_year_and_month.month,
          @dmer1_calc_data.end_date_day,
        )

      end

      # 締め日
      @dmer1_closing_date_year_and_month = @month.since(@dmer1_calc_data.closing_date_month.month)
      if @dmer1_calc_data.closing_date_day == 0
        @dmer1_closing_date = Date.new(
          @dmer1_closing_date_year_and_month.year,
          @dmer1_closing_date_year_and_month.month,
          @dmer1_closing_date_year_and_month.end_of_month.day,
        )
      else
        @dmer1_closing_date = Date.new(
          @dmer1_closing_date_year_and_month.year,
          @dmer1_closing_date_year_and_month.month,
          @dmer1_calc_data.closing_date_day,
        )

      end
      # 期間
      @dmer2_start_date_year_and_month = @month.since(@dmer2_calc_data.start_date_month.month)
      if @dmer2_calc_data.start_date_day == 0
        @dmer2_start_date = Date.new(
          @dmer2_start_date_year_and_month.year,
          @dmer2_start_date_year_and_month.month,
          @dmer2_start_date_year_and_month.end_of_month.day,
        )
      else
        @dmer2_start_date = Date.new(
          @dmer2_start_date_year_and_month.year,
          @dmer2_start_date_year_and_month.month,
          @dmer2_calc_data.start_date_day,
        )

      end 

      @dmer2_end_date_year_and_month = @month.since(@dmer2_calc_data.end_date_month.month)
      if @dmer2_calc_data.end_date_day == 0
        @dmer2_end_date = Date.new(
          @dmer2_end_date_year_and_month.year,
          @dmer2_end_date_year_and_month.month,
          @dmer2_end_date_year_and_month.end_of_month.day,
        )
      else
        @dmer2_end_date = Date.new(
          @dmer2_end_date_year_and_month.year,
          @dmer2_end_date_year_and_month.month,
          @dmer2_calc_data.end_date_day,
        )

      end

      # 締め日
      @dmer2_closing_date_year_and_month = @month.since(@dmer2_calc_data.closing_date_month.month)
      if @dmer2_calc_data.closing_date_day == 0
        @dmer2_closing_date = Date.new(
          @dmer2_closing_date_year_and_month.year,
          @dmer2_closing_date_year_and_month.month,
          @dmer2_closing_date_year_and_month.end_of_month.day,
        )
      else
        @dmer2_closing_date = Date.new(
          @dmer2_closing_date_year_and_month.year,
          @dmer2_closing_date_year_and_month.month,
          @dmer2_calc_data.closing_date_day,
        )

      end
      # 期間
      @dmer3_start_date_year_and_month = @month.since(@dmer3_calc_data.start_date_month.month)
      if @dmer3_calc_data.start_date_day == 0
        @dmer3_start_date = Date.new(
          @dmer3_start_date_year_and_month.year,
          @dmer3_start_date_year_and_month.month,
          @dmer3_start_date_year_and_month.end_of_month.day,
        )
      else
        @dmer3_start_date = Date.new(
          @dmer3_start_date_year_and_month.year,
          @dmer3_start_date_year_and_month.month,
          @dmer3_calc_data.start_date_day,
        )

      end 

      @dmer3_end_date_year_and_month = @month.since(@dmer3_calc_data.end_date_month.month)
      if @dmer3_calc_data.end_date_day == 0
        @dmer3_end_date = Date.new(
          @dmer3_end_date_year_and_month.year,
          @dmer3_end_date_year_and_month.month,
          @dmer3_end_date_year_and_month.end_of_month.day,
        )
      else
        @dmer3_end_date = Date.new(
          @dmer3_end_date_year_and_month.year,
          @dmer3_end_date_year_and_month.month,
          @dmer3_calc_data.end_date_day,
        )

      end
      # 締め日
      @dmer3_closing_date_year_and_month = @month.since(@dmer3_calc_data.closing_date_month.month)
      if @dmer3_calc_data.closing_date_day == 0
        @dmer3_closing_date = Date.new(
          @dmer3_closing_date_year_and_month.year,
          @dmer3_closing_date_year_and_month.month,
          @dmer3_closing_date_year_and_month.end_of_month.day,
        )
      else
        @dmer3_closing_date = Date.new(
          @dmer3_closing_date_year_and_month.year,
          @dmer3_closing_date_year_and_month.month,
          @dmer3_calc_data.closing_date_day,
        )

      end
      # 期間
      @aupay1_start_date_year_and_month = @month.since(@aupay1_calc_data.start_date_month.month)
      if @aupay1_calc_data.start_date_day == 0
        @aupay1_start_date = Date.new(
          @aupay1_start_date_year_and_month.year,
          @aupay1_start_date_year_and_month.month,
          @aupay1_start_date_year_and_month.end_of_month.day,
        )
      else
        @aupay1_start_date = Date.new(
          @aupay1_start_date_year_and_month.year,
          @aupay1_start_date_year_and_month.month,
          @aupay1_calc_data.start_date_day,
        )

      end 

      @aupay1_end_date_year_and_month = @month.since(@aupay1_calc_data.end_date_month.month)
      if @aupay1_calc_data.end_date_day == 0
        @aupay1_end_date = Date.new(
          @aupay1_end_date_year_and_month.year,
          @aupay1_end_date_year_and_month.month,
          @aupay1_end_date_year_and_month.end_of_month.day,
        )
      else
        @aupay1_end_date = Date.new(
          @aupay1_end_date_year_and_month.year,
          @aupay1_end_date_year_and_month.month,
          @aupay1_calc_data.end_date_day,
        )

      end

      # 締め日
      @aupay1_closing_date_year_and_month = @month.since(@aupay1_calc_data.closing_date_month.month)
      if @aupay1_calc_data.closing_date_day == 0
        @aupay1_closing_date = Date.new(
          @aupay1_closing_date_year_and_month.year,
          @aupay1_closing_date_year_and_month.month,
          @aupay1_closing_date_year_and_month.end_of_month.day,
        )
      else
        @aupay1_closing_date = Date.new(
          @aupay1_closing_date_year_and_month.year,
          @aupay1_closing_date_year_and_month.month,
          @aupay1_calc_data.closing_date_day,
        )

      end
      # 期間
      @paypay1_start_date_year_and_month = @month.since(@paypay1_calc_data.start_date_month.month)
      if @paypay1_calc_data.start_date_day == 0
        @paypay1_start_date = Date.new(
          @paypay1_start_date_year_and_month.year,
          @paypay1_start_date_year_and_month.month,
          @paypay1_start_date_year_and_month.end_of_month.day,
        )
      else
        @paypay1_start_date = Date.new(
          @paypay1_start_date_year_and_month.year,
          @paypay1_start_date_year_and_month.month,
          @paypay1_calc_data.start_date_day,
        )

      end 

      @paypay1_end_date_year_and_month = @month.since(@paypay1_calc_data.end_date_month.month)
      if @paypay1_calc_data.end_date_day == 0
        @paypay1_end_date = Date.new(
          @paypay1_end_date_year_and_month.year,
          @paypay1_end_date_year_and_month.month,
          @paypay1_end_date_year_and_month.end_of_month.day,
        )
      else
        @paypay1_end_date = Date.new(
          @paypay1_end_date_year_and_month.year,
          @paypay1_end_date_year_and_month.month,
          @paypay1_calc_data.end_date_day,
        )

      end

      # 締め日
      @paypay1_closing_date_year_and_month = @month.since(@paypay1_calc_data.closing_date_month.month)
      if @paypay1_calc_data.closing_date_day == 0
        @paypay1_closing_date = Date.new(
          @paypay1_closing_date_year_and_month.year,
          @paypay1_closing_date_year_and_month.month,
          @paypay1_closing_date_year_and_month.end_of_month.day,
        )
      else
        @paypay1_closing_date = Date.new(
          @paypay1_closing_date_year_and_month.year,
          @paypay1_closing_date_year_and_month.month,
          @paypay1_calc_data.closing_date_day,
        )

      end
      # 期間
      @rakuten_pay1_start_date_year_and_month = @month.since(@rakuten_pay1_calc_data.start_date_month.month)
      if @rakuten_pay1_calc_data.start_date_day == 0
        @rakuten_pay1_start_date = Date.new(
          @rakuten_pay1_start_date_year_and_month.year,
          @rakuten_pay1_start_date_year_and_month.month,
          @rakuten_pay1_start_date_year_and_month.end_of_month.day,
        )
      else
        @rakuten_pay1_start_date = Date.new(
          @rakuten_pay1_start_date_year_and_month.year,
          @rakuten_pay1_start_date_year_and_month.month,
          @rakuten_pay1_calc_data.start_date_day,
        )

      end 

      @rakuten_pay1_end_date_year_and_month = @month.since(@rakuten_pay1_calc_data.end_date_month.month)
      if @rakuten_pay1_calc_data.end_date_day == 0
        @rakuten_pay1_end_date = Date.new(
          @rakuten_pay1_end_date_year_and_month.year,
          @rakuten_pay1_end_date_year_and_month.month,
          @rakuten_pay1_end_date_year_and_month.end_of_month.day,
        )
      else
        @rakuten_pay1_end_date = Date.new(
          @rakuten_pay1_end_date_year_and_month.year,
          @rakuten_pay1_end_date_year_and_month.month,
          @rakuten_pay1_calc_data.end_date_day,
        )

      end


      # 締め日
      @rakuten_pay1_closing_date_year_and_month = @month.since(@rakuten_pay1_calc_data.closing_date_month.month)
      if @rakuten_pay1_calc_data.closing_date_day == 0
        @rakuten_pay1_closing_date = Date.new(
          @rakuten_pay1_closing_date_year_and_month.year,
          @rakuten_pay1_closing_date_year_and_month.month,
          @rakuten_pay1_closing_date_year_and_month.end_of_month.day,
        )
      else
        @rakuten_pay1_closing_date = Date.new(
          @rakuten_pay1_closing_date_year_and_month.year,
          @rakuten_pay1_closing_date_year_and_month.month,
          @rakuten_pay1_calc_data.closing_date_day,
        )

      end
      # 期間
      @airpay1_start_date_year_and_month = @month.since(@airpay1_calc_data.start_date_month.month)
      if @airpay1_calc_data.start_date_day == 0
        @airpay1_start_date = Date.new(
          @airpay1_start_date_year_and_month.year,
          @airpay1_start_date_year_and_month.month,
          @airpay1_start_date_year_and_month.end_of_month.day,
        )
      else
        @airpay1_start_date = Date.new(
          @airpay1_start_date_year_and_month.year,
          @airpay1_start_date_year_and_month.month,
          @airpay1_calc_data.start_date_day,
        )

      end 

      @airpay1_end_date_year_and_month = @month.since(@airpay1_calc_data.end_date_month.month)
      if @airpay1_calc_data.end_date_day == 0
        @airpay1_end_date = Date.new(
          @airpay1_end_date_year_and_month.year,
          @airpay1_end_date_year_and_month.month,
          @airpay1_end_date_year_and_month.end_of_month.day,
        )
      else
        @airpay1_end_date = Date.new(
          @airpay1_end_date_year_and_month.year,
          @airpay1_end_date_year_and_month.month,
          @airpay1_calc_data.end_date_day,
        )

      end


      # 締め日
      @airpay1_closing_date_year_and_month = @month.since(@airpay1_calc_data.closing_date_month.month)
      if @airpay1_calc_data.closing_date_day == 0
        @airpay1_closing_date = Date.new(
          @airpay1_closing_date_year_and_month.year,
          @airpay1_closing_date_year_and_month.month,
          @airpay1_closing_date_year_and_month.end_of_month.day,
        )
      else
        @airpay1_closing_date = Date.new(
          @airpay1_closing_date_year_and_month.year,
          @airpay1_closing_date_year_and_month.month,
          @airpay1_calc_data.closing_date_day,
        )

      end
      # 期間
      @demaekan1_start_date_year_and_month = @month.since(@demaekan1_calc_data.start_date_month.month)
      if @demaekan1_calc_data.start_date_day == 0
        @demaekan1_start_date = Date.new(
          @demaekan1_start_date_year_and_month.year,
          @demaekan1_start_date_year_and_month.month,
          @demaekan1_start_date_year_and_month.end_of_month.day,
        )
      else
        @demaekan1_start_date = Date.new(
          @demaekan1_start_date_year_and_month.year,
          @demaekan1_start_date_year_and_month.month,
          @demaekan1_calc_data.start_date_day,
        )

      end 

      @demaekan1_end_date_year_and_month = @month.since(@demaekan1_calc_data.end_date_month.month)
      if @demaekan1_calc_data.end_date_day == 0
        @demaekan1_end_date = Date.new(
          @demaekan1_end_date_year_and_month.year,
          @demaekan1_end_date_year_and_month.month,
          @demaekan1_end_date_year_and_month.end_of_month.day,
        )
      else
        @demaekan1_end_date = Date.new(
          @demaekan1_end_date_year_and_month.year,
          @demaekan1_end_date_year_and_month.month,
          @demaekan1_calc_data.end_date_day,
        )

      end


      # 締め日
      @demaekan1_closing_date_year_and_month = @month.since(@demaekan1_calc_data.closing_date_month.month)
      if @demaekan1_calc_data.closing_date_day == 0
        @demaekan1_closing_date = Date.new(
          @demaekan1_closing_date_year_and_month.year,
          @demaekan1_closing_date_year_and_month.month,
          @demaekan1_closing_date_year_and_month.end_of_month.day,
        )
      else
        @demaekan1_closing_date = Date.new(
          @demaekan1_closing_date_year_and_month.year,
          @demaekan1_closing_date_year_and_month.month,
          @demaekan1_calc_data.closing_date_day,
        )

      end
      # 期間
      @austicker1_start_date_year_and_month = @month.since(@austicker1_calc_data.start_date_month.month)
      if @austicker1_calc_data.start_date_day == 0
        @austicker1_start_date = Date.new(
          @austicker1_start_date_year_and_month.year,
          @austicker1_start_date_year_and_month.month,
          @austicker1_start_date_year_and_month.end_of_month.day,
        )
      else
        @austicker1_start_date = Date.new(
          @austicker1_start_date_year_and_month.year,
          @austicker1_start_date_year_and_month.month,
          @austicker1_calc_data.start_date_day,
        )

      end 

      @austicker1_end_date_year_and_month = @month.since(@austicker1_calc_data.end_date_month.month)
      if @austicker1_calc_data.end_date_day == 0
        @austicker1_end_date = Date.new(
          @austicker1_end_date_year_and_month.year,
          @austicker1_end_date_year_and_month.month,
          @austicker1_end_date_year_and_month.end_of_month.day,
        )
      else
        @austicker1_end_date = Date.new(
          @austicker1_end_date_year_and_month.year,
          @austicker1_end_date_year_and_month.month,
          @austicker1_calc_data.end_date_day,
        )

      end

      # 締め日
      @austicker1_closing_date_year_and_month = @month.since(@austicker1_calc_data.closing_date_month.month)
      if @austicker1_calc_data.closing_date_day == 0
        @austicker1_closing_date = Date.new(
          @austicker1_closing_date_year_and_month.year,
          @austicker1_closing_date_year_and_month.month,
          @austicker1_closing_date_year_and_month.end_of_month.day,
        )
      else
        @austicker1_closing_date = Date.new(
          @austicker1_closing_date_year_and_month.year,
          @austicker1_closing_date_year_and_month.month,
          @austicker1_calc_data.closing_date_day,
        )

      end
      # 期間
      @dmersticker1_start_date_year_and_month = @month.since(@dmersticker1_calc_data.start_date_month.month)
      if @dmersticker1_calc_data.start_date_day == 0
        @dmersticker1_start_date = Date.new(
          @dmersticker1_start_date_year_and_month.year,
          @dmersticker1_start_date_year_and_month.month,
          @dmersticker1_start_date_year_and_month.end_of_month.day,
        )
      else
        @dmersticker1_start_date = Date.new(
          @dmersticker1_start_date_year_and_month.year,
          @dmersticker1_start_date_year_and_month.month,
          @dmersticker1_calc_data.start_date_day,
        )

      end 

      @dmersticker1_end_date_year_and_month = @month.since(@dmersticker1_calc_data.end_date_month.month)
      if @dmersticker1_calc_data.end_date_day == 0
        @dmersticker1_end_date = Date.new(
          @dmersticker1_end_date_year_and_month.year,
          @dmersticker1_end_date_year_and_month.month,
          @dmersticker1_end_date_year_and_month.end_of_month.day,
        )
      else
        @dmersticker1_end_date = Date.new(
          @dmersticker1_end_date_year_and_month.year,
          @dmersticker1_end_date_year_and_month.month,
          @dmersticker1_calc_data.end_date_day,
        )

      end

      # 締め日
      @dmersticker1_closing_date_year_and_month = @month.since(@dmersticker1_calc_data.closing_date_month.month)
      if @dmersticker1_calc_data.closing_date_day == 0
        @dmersticker1_closing_date = Date.new(
          @dmersticker1_closing_date_year_and_month.year,
          @dmersticker1_closing_date_year_and_month.month,
          @dmersticker1_closing_date_year_and_month.end_of_month.day,
        )
      else
        @dmersticker1_closing_date = Date.new(
          @dmersticker1_closing_date_year_and_month.year,
          @dmersticker1_closing_date_year_and_month.month,
          @dmersticker1_calc_data.closing_date_day,
        )

      end
      
      # 成約率
      @dmer1_this_month_per = @dmer1_calc_data.this_month_per
      @dmer1_prev_month_per = @dmer1_calc_data.prev_month_per
      @dmer2_this_month_per = @dmer2_calc_data.this_month_per
      @dmer2_prev_month_per = @dmer2_calc_data.prev_month_per
      @dmer3_this_month_per = @dmer3_calc_data.this_month_per
      @dmer3_prev_month_per = @dmer3_calc_data.prev_month_per
      @aupay1_prev_month_per = @aupay1_calc_data.prev_month_per
      @paypay1_this_month_per = @paypay1_calc_data.this_month_per
      @paypay1_prev_month_per = @paypay1_calc_data.prev_month_per
      @rakuten_pay1_this_month_per = @rakuten_pay1_calc_data.this_month_per
      @rakuten_pay1_prev_month_per = @rakuten_pay1_calc_data.prev_month_per
      @airpay1_this_month_per = @airpay1_calc_data.this_month_per
      @airpay1_prev_month_per = @airpay1_calc_data.prev_month_per
      @demaekan1_this_month_per = @demaekan1_calc_data.this_month_per
      @demaekan1_prev_month_per = @demaekan1_calc_data.prev_month_per
      @austicker1_this_month_per = @austicker1_calc_data.this_month_per
      @austicker1_prev_month_per = @austicker1_calc_data.prev_month_per
      @dmersticker1_this_month_per = @dmersticker1_calc_data.this_month_per
      @dmersticker1_prev_month_per = @dmersticker1_calc_data.prev_month_per

      # 大元の成約率
      @closing_span = (@closing_date.to_date - @end_date.to_date).to_i
      @period_span = (Date.today.to_date - @end_date.to_date).to_i
      # 増加率
      if Date.today.to_date >= @end_date.to_date
      # dメル
      @dmer1_inc_per = (1.0 - @dmer1_this_month_per) / @closing_span * @period_span
      @dmer2_inc_per = (1.0 - @dmer2_this_month_per) / @closing_span * @period_span
      @dmer3_inc_per = (1.0 - @dmer3_this_month_per) / @closing_span * @period_span
      @dmer1_prev_inc_per = (1.0 - @dmer1_prev_month_per) / @closing_span * @period_span
      @dmer2_prev_inc_per = (1.0 - @dmer2_prev_month_per) / @closing_span * @period_span
      # auPay
      @aupay_prev_inc_per = (1.0 - @aupay1_prev_month_per) / @closing_span * @period_span
      # AirPay
      @airpay_inc_per = (1.0 - @airpay1_this_month_per) / @closing_span * @period_span
      @airpay_prev_inc_per = (1.0 - @airpay1_prev_month_per) / @closing_span * @period_span
      # 減少率
      # dメル
      @dmer1_dec_per = @dmer1_this_month_per / @closing_span * @period_span
      @dmer2_dec_per = @dmer2_this_month_per / @closing_span * @period_span
      @dmer3_dec_per = @dmer3_this_month_per / @closing_span * @period_span
      @dmer1_prev_dec_per = @dmer1_prev_month_per / @closing_span * @period_span
      @dmer2_prev_dec_per = @dmer2_prev_month_per / @closing_span * @period_span
      # auPay
      @aupay_prev_dec_per = @aupay1_prev_month_per / @closing_span * @period_span
      # AirPay
      @airpay_dec_per = @airpay1_this_month_per / @closing_span * @period_span
      @airpay_prev_dec_per = @airpay1_prev_month_per / @closing_span * @period_span
      else  
      # dメル
      @dmer1_inc_per = 0
      @dmer2_inc_per = 0
      @dmer3_inc_per = 0
      @dmer1_prev_inc_per = 0
      @dmer2_prev_inc_per = 0
      # auPay
      @aupay_inc_per = 0
      @aupay_prev_inc_per = 0
      # AirPay
      @airpay_inc_per = 0
      @airpay_prev_inc_per = 0
      # 減少率
      # dメル
      @dmer1_dec_per = 0
      @dmer2_dec_per = 0
      @dmer3_dec_per = 0
      @dmer1_prev_dec_per = 0
      @dmer2_prev_dec_per = 0
      # auPay
      @aupay_dec_per = 0
      @aupay_prev_dec_per = 0
      # AirPay
      @airpay_dec_per = 0
      @airpay_prev_dec_per = 0
      end 
      # 単価
      @dmer1_price = @dmer1_calc_data.price
      @dmer2_price = @dmer2_calc_data.price
      @dmer3_price = @dmer3_calc_data.price
      @aupay1_price = @aupay1_calc_data.price
      @paypay_price = @paypay1_calc_data.price
      @rakuten_pay_price = @rakuten_pay1_calc_data.price
      @airpay_price = @airpay1_calc_data.price

      # 獲得件数に合わせたインセンティブ
      @airpay_bonus1_len = @airpay1_calc_data.bonus1_len
      @airpay_bonus1_price = @airpay1_calc_data.bonus1_price
      @airpay_bonus2_len = @airpay1_calc_data.bonus2_len
      @airpay_bonus2_price = @airpay1_calc_data.bonus2_price
    end 

    # 実売資料の関数
    def profit_pack
      # calc_period_and_perは"@calc_periods"と"@month"の配置を先にするのが必須
      calc_period_and_per
      # 期間
      @results = 
        Result.includes(:user,:result_cash).where(shift: "キャッシュレス新規").where(date: @start_date..@end_date)
        .or(Result.includes(:user,:result_cash).where(shift: "キャッシュレス決済").where(date: @start_date..@end_date))
      @shifts = 
        Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス新規")
        .or(Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス決済"))
      # 楽天ペイ全体
      rakuten_all_len = RakutenPay.where(status: "OK").where(result_point: @rakuten_pay1_start_date..@rakuten_pay1_end_date).length
      rakuten_all_len_prev = RakutenPay.where(status: "OK").where(result_point: @rakuten_pay1_start_date.prev_month..@rakuten_pay1_end_date.prev_month).length
      # 全体AirPay
      airpay_all = 
      Airpay.where(date: @start_date..@end_date).where(status: "審査完了")
      .or(
        Airpay.where(date: @start_date..@end_date).where(status: "審査中")
      )
      airpay_all_len = airpay_all.length
      airpay_all_len_ave = (airpay_all_len.to_f / @results.where(shift: "キャッシュレス新規").length).round(1)
      airpay_all_len_fin = (airpay_all_len_ave * @shifts.where(shift: "キャッシュレス新規").length * @airpay1_this_month_per).round() rescue 0
      # AirPay単価
      @airpay_price = 
      if airpay_all_len_fin >= @airpay_bonus2_len
        @airpay_bonus2_price
      elsif airpay_all_len_fin >= @airpay_bonus1_len
        @airpay_bonus1_price
      else  
        @airpay_price
      end 
      # 成果率

      # ハッシュ・リストデータ
      @chubu_cash_list = []
      @kansai_cash_list = []
      @kanto_cash_list = []
      @kyushu_cash_list = []
      @partner_cash_list = []
      @femto_list = []
      @summit_list = []
      @retire_list = []
      @all_list = []
      @bases = ["中部SS", "関西SS", "関東SS","九州SS", "2次店","退職"]
      @users = 
        User.where(base_sub: "キャッシュレス")
        .or(
          User.where(base_sub: "フェムト")
        )
        .or(
          User.where(base_sub: "サミット")
        )
      # ハッシュの中身
        @bases.each do |base| # 拠点ごとに繰り返す
          @users.where(base: base).each do |user| #ユーザーごとに繰り返す
            person_hash = {}
          # ユーザー情報
            user_result = @results.where(user_id: user.id)
            if user.position == "退職"
              person_hash["拠点"] = "その他"
            elsif user.base_sub == "フェムト"
              person_hash["拠点"] = "フェムト"
            elsif user.base_sub == "サミット"
              person_hash["拠点"] = "サミット"
            else  
              person_hash["拠点"] = user.base 
            end
            person_hash["名前"] = user.name
            person_hash["役職"] = user.position_sub
          # 予定シフト
            user_shift = @shifts.where(user_id: user.id)
            person_hash["予定シフト"] = user_shift.length
            person_hash["予定新規シフト"] = user_shift.where(shift: "キャッシュレス新規").length
            person_hash["予定決済シフト"] = user_shift.where(shift: "キャッシュレス決済").length
            person_hash["予定決済シフト"] = user_shift.where(shift: "キャッシュレス決済").length
            person_hash["予定帯同シフト"] = Shift.where(start_time: @start_date..@end_date).where(shift: "帯同").length
          # 消化シフト
            user_result_shift = 
              user_result.where(shift: "キャッシュレス新規")
                .or(user_result.where(shift: "キャッシュレス決済"))
                .or(user_result.where(shift: "帯同"))
            person_hash["消化シフト"] = user_result_shift.length 
            person_hash["消化新規シフト"] = user_result_shift.where(shift: "キャッシュレス新規").length 
            person_hash["消化決済シフト"] = user_result_shift.where(shift: "キャッシュレス決済").length 
            person_hash["消化帯同シフト"] = Result.where(date: @start_date..@end_date).where(shift: "帯同").length 
          # 基準値
            person_hash["訪問"] = (user_result.sum("first_total_visit + latter_total_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
            person_hash["応答"] = (user_result.sum("first_visit + latter_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
            person_hash["対面"] = (user_result.sum("first_interview + latter_interview").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
            person_hash["フル"] = (user_result.sum("first_full_talk + latter_full_talk").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
            person_hash["獲得"] = (user_result.sum("first_get + latter_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          # 切り返し
          person_hash["０１：どうゆうこと？：対面"] = (user_result.sum("out_interview_01").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０１：どうゆうこと？：フル"] = (user_result.sum("out_full_talk_01").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０１：どうゆうこと？：成約"] = (user_result.sum("out_get_01").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０２：君は誰？協会？：対面"] = (user_result.sum("out_interview_02").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０２：君は誰？協会？：フル"] = (user_result.sum("out_full_talk_02").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０２：君は誰？協会？：成約"] = (user_result.sum("out_get_02").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０３：もらうだけでいいの？：対面"] = (user_result.sum("out_interview_03").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０３：もらうだけでいいの？：フル"] = (user_result.sum("out_full_talk_03").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０３：もらうだけでいいの？：成約"] = (user_result.sum("out_get_03").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０４：PayPayのみ：対面"] = (user_result.sum("out_interview_04").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０４：PayPayのみ：フル"] = (user_result.sum("out_full_talk_04").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０４：PayPayのみ：成約"] = (user_result.sum("out_get_04").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０５：AirPayのみ：対面"] = (user_result.sum("out_interview_05").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０５：AirPayのみ：フル"] = (user_result.sum("out_full_talk_05").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０５：AirPayのみ：成約"] = (user_result.sum("out_get_05").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０６：カードのみ：対面"] = (user_result.sum("out_interview_06").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０６：カードのみ：フル"] = (user_result.sum("out_full_talk_06").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０６：カードのみ：成約"] = (user_result.sum("out_get_06").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０７：先延ばし：対面"] = (user_result.sum("out_interview_07").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０７：先延ばし：フル"] = (user_result.sum("out_full_talk_07").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０７：先延ばし：成約"] = (user_result.sum("out_get_07").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０８：現金のみ：対面"] = (user_result.sum("out_interview_08").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０８：現金のみ：フル"] = (user_result.sum("out_full_talk_08").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０８：現金のみ：成約"] = (user_result.sum("out_get_08").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０９：忙しい：対面"] = (user_result.sum("out_interview_09").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０９：忙しい：フル"] = (user_result.sum("out_full_talk_09").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０９：忙しい：成約"] = (user_result.sum("out_get_09").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１０：面倒くさい：対面"] = (user_result.sum("out_interview_10").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１０：面倒くさい：フル"] = (user_result.sum("out_full_talk_10").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１０：面倒くさい：成約"] = (user_result.sum("out_get_10").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１１：情報不足：対面"] = (user_result.sum("out_interview_11").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１１：情報不足：フル"] = (user_result.sum("out_full_talk_11").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１１：情報不足：成約"] = (user_result.sum("out_get_11").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１２：ペロ：対面"] = (user_result.sum("out_interview_12").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１２：ペロ：フル"] = (user_result.sum("out_full_talk_12").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１２：ペロ：成約"] = (user_result.sum("out_get_12").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１３：その他：対面"] = (user_result.sum("out_interview_13").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１３：その他：フル"] = (user_result.sum("out_full_talk_13").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１３：その他：成約"] = (user_result.sum("out_get_13").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["喫茶・カフェ訪問数"] = (user_result.sum("cafe_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["喫茶・カフェ獲得数"] = (user_result.sum("cafe_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["その他飲食訪問数"] = (user_result.sum("other_food_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["その他飲食獲得数"] = (user_result.sum("other_food_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["車屋訪問数"] = (user_result.sum("car_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["車屋獲得数"] = (user_result.sum("car_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["その他小売訪問数"] = (user_result.sum("other_retail_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["その他小売獲得数"] = (user_result.sum("other_retail_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["理容・美容訪問数"] = (user_result.sum("hair_salon_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["理容・美容獲得数"] = (user_result.sum("hair_salon_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["整体・鍼灸訪問数"] = (user_result.sum("manipulative_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["整体・鍼灸獲得数"] = (user_result.sum("manipulative_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["その他サービス訪問数"] = (user_result.sum("other_service_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["その他サービス獲得数"] = (user_result.sum("other_service_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          # dメル
            dmer_user = 
              Dmer.where(user_id: user.id).includes(:store_prop)
            dmer_slmter = 
              Dmer.where(settlementer_id: user.id)
            # 現状売上
              # 第一成果
              dmer_result1 = 
                dmer_user.where(result_point: @dmer1_start_date..@dmer1_end_date)
                .where("? >= settlement", @dmer1_end_date)
                .where(status: "審査OK")
                .where.not(industry_status: "NG")
                .where.not(industry_status: "×")
                .where.not(industry_status: "要確認")
                .or(
                  dmer_user.where(settlement: @dmer1_start_date..@dmer1_end_date)
                  .where("? >= result_point", @dmer1_end_date)
                  .where(status: "審査OK")
                  .where.not(industry_status: "NG")
                  .where.not(industry_status: "×")
                  .where.not(industry_status: "要確認")
                )
              dmer_result1_profit = dmer_result1.sum(:profit_new)
              # 26-末日までに成果になった案件（前月の売上になっているもの）
              dmer1_val_26_end_of_month = 
                dmer_user.where(result_point: @start_date...@dmer1_start_date)
                .where("? > settlement", @dmer1_start_date)
                .where(date: @start_date...@dmer1_start_date)
                .where(status: "審査OK")
                .where.not(industry_status: "NG")
                .where.not(industry_status: "×")
                .where.not(industry_status: "要確認")
                .or(
                  dmer_user.where(settlement: @start_date...@dmer1_start_date)
                  .where(date: @start_date...@dmer1_start_date)
                  .where("? > result_point", @dmer1_start_date)
                  .where(status: "審査OK")
                  .where.not(industry_status: "NG")
                  .where.not(industry_status: "×")
                  .where.not(industry_status: "要確認")
                )
                dmer2_val_26_end_of_month = dmer1_val_26_end_of_month.where(status_update_settlement: @start_date...@dmer2_start_date)
                dmer3_val_26_end_of_month = dmer2_val_26_end_of_month.where("? > settlement_second", @dmer3_start_date)
              person_hash["dメル第一成果件数"] = dmer_result1.length
              person_hash["dメル現状売上1"] = dmer_result1_profit
              # 第二成果
              dmer_result2 = 
                dmer_slmter.where(status_update_settlement: @dmer2_start_date..@dmer2_end_date)
                .where(status: "審査OK")
                .where.not(industry_status: "NG")
                .where.not(industry_status: "×")
                .where.not(industry_status: "要確認")
                .where(status_settlement: "完了")
  
                dmer_result2_profit = dmer_result2.sum(:profit_settlement)
              person_hash["dメル第二成果件数"] = dmer_result2.length
              person_hash["dメル現状売上2"] = dmer_result2_profit
              # 第三成果
              dmer_result3 = 
                dmer_slmter.where(settlement_second: @dmer3_start_date..@dmer3_end_date)
                .where("? >= status_update_settlement", @dmer3_end_date)
                .where(status: "審査OK")
                .where.not(industry_status: "NG")
                .where.not(industry_status: "×")
                .where.not(industry_status: "要確認")
                .where(status_settlement: "完了")
                .or(
                  dmer_slmter
                  .where(status_update_settlement: @dmer3_start_date..@dmer3_end_date)
                  .where("? >= settlement_second", @dmer3_end_date)
                  .where(status: "審査OK")
                  .where.not(industry_status: "NG")
                  .where.not(industry_status: "×")
                  .where.not(industry_status: "要確認")
                  .where(status_settlement: "完了")
                )
              dmer_result3_profit = dmer_result3.sum(:profit_second_settlement)
              person_hash["dメル第三成果件数"] = dmer_result3.length
              person_hash["dメル現状売上3"] = dmer_result3_profit
            
            # 獲得数
              dmer_uq = dmer_user.where(date: @start_date..@end_date).where(store_prop: {head_store: nil})
              person_hash["dメルアクセプタンス数"] = dmer_slmter.where(picture: @start_date..@end_date).length 
              person_hash["dメル2回目決済数"] = dmer_slmter.where(settlement_second: @start_date..@end_date).length
  
              dmer_def =  dmer_uq.where(status: "自社不備")
              .or(dmer_uq.where(status: "審査NG"))
              .or(dmer_uq.where(status: "申込取消"))
              .or(dmer_uq.where(status: "申込取消（不備）"))
              .or(dmer_uq.where(status: "社内確認中"))
              .or(dmer_uq.where(status: "審査OK").where(industry_status: "NG"))
              .or(dmer_uq.where(status: "審査OK").where(industry_status: "×"))
              .or(dmer_uq.where(status: "不備対応中"))
              dmer_db = 
              dmer_user.where(share: @start_date..@end_date).where.not(store_prop: {head_store: nil})
              .where.not(industry_status: "×").where.not(industry_status: "NG").where.not(industry_status: "要確認")
              .where.not(status: "不備対応中")
              .where.not(status: "審査NG")
              .where.not(status: "本店審査待ち")
              dmer_len = dmer_uq.length  - dmer_def.length + dmer_db.length #評価件数
              dmer_slmt2nd = dmer_slmter.where(settlement_second: @dmer3_start_date..@dmer3_end_date)
              person_hash["dメル獲得数"] = dmer_uq.length
              if dmer_len == 0
                dmer_len_ave = 0
              else
                dmer_len_ave = (dmer_len.to_f / person_hash["消化新規シフト"]).round(1) rescue 0
              end 
            # 評価件数
              dmer_val1_period =  
              dmer_user.where(status: "審査OK")
              .where.not(industry_status: "×")
              .where.not(industry_status: "NG")
              .where.not(industry_status: "要確認")
              .where(date: @start_date..@end_date)
              dmer_val1_period = 
                dmer_val1_period.where(result_point: @start_date..@dmer1_end_date)
                .where("? >= settlement",@dmer1_end_date)
                .or(
                  dmer_val1_period.where(settlement: @start_date..@dmer1_end_date)
                  .where("? >= result_point",@dmer1_end_date)
                )
                
              dmer_val2_period = 
              dmer_user.where(status: "審査OK")
              .where.not(industry_status: "×")
              .where.not(industry_status: "NG")
              .where.not(industry_status: "要確認")
              .where(date: @start_date..@end_date)
              .where("? >= status_update_settlement",@dmer2_end_date)
              .where(status_settlement: "完了")
              dmer_val3_period = dmer_val2_period.where.not(settlement_second: nil)
              dmer_val1_period_len = dmer_val1_period.length
              dmer_val2_period_len = dmer_val2_period.length
              dmer_val3_period_len = dmer_val3_period.length

            # 過去月の決済対象
              dmer_slmt_tgt_prev = 
                dmer_user.where("settlement_deadline >= ?", @start_date)
                .where("? > date", @start_date)
                .where(status: "審査OK")
                .where.not(industry_status: "×")
                .where.not(industry_status: "NG")
                .where.not(industry_status: "要確認")
                dmer_slmt_tgt_prev_len = dmer_slmt_tgt_prev.length rescue 0
              # 過去母体
              dmer1_tgt_prev = dmer_slmt_tgt_prev.where(settlement: nil)
              dmer2_tgt_prev = dmer_slmt_tgt_prev.where(status_update_settlement: nil)
              person_hash["dメル1過去母体"] = dmer1_tgt_prev.length 
              person_hash["dメル2過去母体"] = dmer2_tgt_prev.length
            # 過去月の決済母体数（第一成果）
                # 決済期限切れ
                dmer_slmt_dead = 
                  dmer_slmt_tgt_prev.where(status_settlement: "期限切れ")
                  .where(status_update_settlement: nil)
                  person_hash["dメル決済期限切れ"] = dmer_slmt_dead.length
                dmer_slmt_dead_len = dmer_slmt_dead.length
                # 過去の案件で対象月に成果になったもの
                dmer1_prev_val = dmer_slmt_tgt_prev.where(settlement: @start_date..@dmer1_end_date)
                dmer2_prev_val =  
                  dmer_slmt_tgt_prev.where(status_update_settlement: @start_date..@dmer1_end_date)
                dmer3_prev_val = 
                  dmer2_prev_val.where("? >= settlement_second", @dmer3_end_date)
                dmer1_prev_val_len = dmer1_prev_val.length
                dmer3_prev_val_len = dmer3_prev_val.length
            # 終着
              # 第一成果
                # 終着獲得数 = 評価件数 / 消化新規シフト * 予定新規シフト * （成果率 - 減少%）
                dmer1_fin_this_month_len = 
                (
                  dmer_len.to_f / person_hash["消化新規シフト"] * person_hash["予定新規シフト"] * (@dmer1_this_month_per - @dmer1_dec_per)
                ).round() rescue 0 
                person_hash["dメル1終着獲得数（期内）"] = dmer1_fin_this_month_len - dmer1_val_26_end_of_month.length
                # 期間内終着売上 = （単価 * 終着獲得数） - 26〜末日までに成果になった案件（前月の売上に既になっている）
                  dme1_fin_this_month = 
                  (@dmer1_price * dmer1_fin_this_month_len) - dmer1_val_26_end_of_month.sum(:profit_new)
  
                # 過去月終着獲得数 = 母体数 * 成果率
                dmer_result1_fin_prev_month_len = 
                (
                  person_hash["dメル1過去母体"].to_f * (@dmer1_prev_month_per - @dmer1_prev_dec_per)
                ).round()
                  dmer_result1_fin_prev_month = 
                    (@dmer1_price * dmer_result1_fin_prev_month_len) + 
                    (
                      @dmer1_price * (dmer_result1.where("? > date",@start_date).length.to_f * (@dmer1_prev_month_per + @dmer1_prev_inc_per)).round()
                    )
                # 合計
                dmer_result1_fin = dme1_fin_this_month + dmer_result1_fin_prev_month
                person_hash["dメル一次成果終着（期内）"] = dme1_fin_this_month
                person_hash["dメル一次成果終着（過去）"] = dmer_result1_fin_prev_month
                if (person_hash["dメル現状売上1"] > dmer_result1_fin) || (Date.today >= @closing_date)
                  person_hash["dメル一次成果終着"] = person_hash["dメル現状売上1"]
                else
                person_hash["dメル一次成果終着"] = dmer_result1_fin
                end 
              # 第二成果
                # 期間内
                dmer2_fin_this_month_len =
                (
                  dmer_len.to_f / person_hash["消化新規シフト"] * person_hash["予定新規シフト"] * (@dmer2_this_month_per - @dmer2_dec_per)
                ).round() rescue 0
                dmer_result2_fin_this_month = 
                (@dmer2_price * dmer2_fin_this_month_len) -
                dmer2_val_26_end_of_month.sum(:profit_settlement)
                person_hash["dメル2終着獲得数（期内）"] = dmer2_fin_this_month_len - dmer2_val_26_end_of_month.length
                # 過去
                dmer2_fin_prev_month_len = 
                  (
                    dmer2_tgt_prev.length.to_f * (@dmer2_prev_month_per - @dmer2_prev_dec_per)
                  ).round()
                dmer_result2_fin_prev_month = 
                (@dmer2_price * dmer2_fin_prev_month_len) + 
                ( (dmer_result2.where("? > date",@start_date).length.to_f * (@dmer2_prev_month_per  + @dmer2_prev_inc_per)).round() * @dmer2_price )
                # 合計
                dmer_result2_fin = dmer_result2_fin_this_month + dmer_result2_fin_prev_month
                person_hash["dメル二次成果終着（期内）"] = dmer_result2_fin_this_month
                person_hash["dメル二次成果終着（過去）"] = dmer_result2_fin_prev_month
                if (person_hash["dメル現状売上2"] > dmer_result2_fin) || (Date.today >= @closing_date)
                  person_hash["dメル二次成果終着"] = person_hash["dメル現状売上2"]
                else
                  person_hash["dメル二次成果終着"] = dmer_result2_fin
                end
              # 第三成果
                dmer_result3 = 
                  dmer_slmter.where(settlement_second: @dmer3_start_date..@dmer3_end_date)
                  .where.not(industry_status: "NG")
                  .where.not(industry_status: "×")
                  .where.not(industry_status: "要確認")
                  .where(status: "審査OK")
                  .where(status_settlement: "完了")
                  .where("? >= status_update_settlement", @dmer3_end_date)
                  .or(
                    dmer_slmter.where(status_update_settlement: @dmer3_start_date..@dmer3_end_date)
                    .where.not(industry_status: "NG")
                    .where.not(industry_status: "×")
                    .where.not(industry_status: "要確認")
                    .where(status: "審査OK")
                    .where(status_settlement: "完了")
                    .where("? >= settlement_second", @dmer3_end_date)
                  )
                dmer_slmt2nd_profits = dmer_result3.sum(:profit_second_settlement)
                dmer_result3_len = dmer_result3.length
                dmer_slmt2nd_len = dmer_slmt2nd.length
                # 期間内
                dmer3_fin_this_month_len = 
                      (
                        dmer_len.to_f / 
                        person_hash["消化新規シフト"] * person_hash["予定新規シフト"] * (@dmer3_this_month_per - @dmer3_dec_per)
                      ).round() rescue 0 
                  dmer_result3_fin_this_month = 
                    (@dmer3_price * dmer3_fin_this_month_len) -
                    dmer3_val_26_end_of_month.sum(:profit_second_settlement)
                dmer_result3_fin_prev_month = 
                  (
                    @dmer3_price * (dmer2_tgt_prev.length - dmer_slmt_dead_len)
                  ) + (dmer_result3.where("? > date",@start_date).sum(:profit_second_settlement))
                dmer_result3_fin = dmer_result3_fin_this_month + dmer_result3_fin_prev_month
                person_hash["dメル3終着獲得数（期内）"] = dmer3_fin_this_month_len - dmer3_val_26_end_of_month.length
                person_hash["dメル三次成果終着（期内）"] = dmer_result3_fin_this_month
                person_hash["dメル三次成果終着（過去）"] = dmer_result3_fin_prev_month
                if (person_hash["dメル現状売上3"] > dmer_result3_fin) || (Date.today >= @closing_date)
                  person_hash["dメル三次成果終着"] = person_hash["dメル現状売上3"]
                else  
                  person_hash["dメル三次成果終着"] = dmer_result3_fin
                end 
          # auPay
            aupay_user = Aupay.includes(:store_prop).where(user_id: user.id)
            aupay_uq = aupay_user.where(date: @start_date..@end_date) 
            aupay_slmter = 
              Aupay.where(settlementer_id: user.id)
            # 過去の決済対象
              aupay_slmt_tgt_prev = 
                aupay_user.where("settlement_deadline >= ?", @start_date)
                .where("? > date", @start_date)
                .where(status: "審査通過")
                .where(status_update_settlement: nil)
              aupay_slmt_tgt_prev_len = aupay_slmt_tgt_prev.length
              aupay_slmt_prev_val = 
              aupay_slmt_tgt_prev.where(status_update_settlement: @aupay1_start_date..@aupay1_end_date)
              aupay_slmt_prev_val_len = aupay_slmt_prev_val.length
            # 現状売上
              # 一次成果
                aupay_result1 = 
                  aupay_slmter.where(status_update_settlement: @aupay1_start_date..@aupay1_end_date)
                  .where(status: "審査通過")
                  .where(status_settlement: "完了")
                aupay_result1_profit = aupay_result1.sum(:profit_settlement)
                person_hash["auPay獲得数"] = aupay_uq.length
                person_hash["auPayアクセプタンス数"] = aupay_slmter.where(picture: @start_date..@end_date).length
                person_hash["auPay第一成果件数"] = aupay_result1.length
                person_hash["auPay現状売上1"] = aupay_result1_profit
            # 終着
              # 一次成果
                # 期間内
                # 過去月
                aupay_result1_fin_prev_month_len = 
                  (
                    aupay_slmt_tgt_prev_len * (@aupay1_prev_month_per - @aupay_prev_dec_per)
                  ).round() rescue 0
                  aupay_result1_fin_prev_month = 
                    (@aupay1_price * aupay_result1_fin_prev_month_len) + 
                    ((aupay_result1.where("? > date", @start_date).length.to_f * (@aupay1_prev_month_per + @aupay_prev_inc_per)).round() * @aupay1_price) rescue 0
                    person_hash["auPay未決済"] = aupay_slmt_tgt_prev_len
                aupay_result1_fin = aupay_result1_fin_prev_month
                if (person_hash["auPay現状売上1"] > aupay_result1_fin) || (Date.today > @closing_date)
                  person_hash["auPay一次成果終着"] = person_hash["auPay現状売上1"]
                else  
                  person_hash["auPay一次成果終着"] = aupay_result1_fin
                end 
          #PayPay
            paypay_user = Paypay.where(user_id: user.id)
            paypay_uq = paypay_user.where(date: @start_date..@end_date)
            # 現状売上
              # 一次成果
              paypay_result1 = paypay_user.where(status: "60審査可決").where(result_point: @paypay1_start_date..@paypay1_end_date)
              paypay_result1_profit = paypay_result1.sum(:profit)
              person_hash["PayPay獲得数"] = paypay_uq.length
              person_hash["PayPay第一成果件数"] = paypay_result1.length
              person_hash["PayPay現状売上"] = paypay_result1_profit
            # 終着売上
              # 一次成果
              paypay_data = paypay_user.where(date: @start_date..@end_date)
              paypay_len = paypay_data.length
              if paypay_len == 0
                paypay_len_ave = 0
              else 
                paypay_len_ave = (paypay_len.to_f / person_hash["消化新規シフト"]).round(1) rescue 0
              end 
              paypay_fin_len = (paypay_len_ave * person_hash["予定新規シフト"]).round() rescue 0 
              paypay_result1_fin = @paypay_price * paypay_fin_len rescue 0
              if (paypay_result1_profit > paypay_result1_fin) || (Date.today >= @closing_date)
                paypay_result1_fin = paypay_result1_profit
              end 
              person_hash["PayPay一次成果終着"] = paypay_result1_fin
          # 楽天ペイ
            rakuten_pay_user = RakutenPay.where(user_id: user.id).where(status: "OK")
            # 一次成果
            rakuten_pay_uq = rakuten_pay_user.where(date: @start_date..@end_date)
            rakuten_pay_result1 = rakuten_pay_user.where(result_point: @rakuten_pay1_start_date..@rakuten_pay1_end_date)
            rakuten_pay_result1_len = rakuten_pay_result1.length 
            rakuten_pay_result1_profit = rakuten_pay_result1.sum(:profit)
            person_hash["楽天ペイ獲得数"] = rakuten_pay_uq.length
            person_hash["楽天ペイ第一成果件数"] = rakuten_pay_result1.length
            person_hash["楽天ペイ現状売上"] = rakuten_pay_result1_profit
            # 終着売上
            rakuten_pay_result1_prev = rakuten_pay_user.where(result_point: @rakuten_pay1_start_date.prev_month..@rakuten_pay1_end_date.prev_month)
            rakuten_pay_result1_prev_len = rakuten_pay_result1_prev.length
            rakuten_pay_result1_prev_profit = rakuten_pay_result1_prev.sum(:profit)
            if (rakuten_all_len >= rakuten_all_len_prev) || (Date.today >= @rakuten_pay1_closing_date)
              rakuten_pay_result1_prev_profit = rakuten_pay_result1_profit
            end 
            person_hash["楽天ペイ一次成果終着"] = rakuten_pay_result1_prev_profit
          # AirPay
            results = Result.includes(:user,:result_cash).where(date: @start_date..@end_date)
            result_user = results.where(user_id: user.id)
            @result_airpay_sum = result_user.sum(:airpay)
  
              airpay_user = airpay_all.where(user_id: user.id)
              airpay_user_len = airpay_user.length
              airpay_len_ave = (airpay_user_len.to_f / person_hash["消化新規シフト"]).round(1) rescue 0
  
            # 一次成果
            airpay_user = 
              Airpay.where(user_id: user.id).where(status: "審査完了")
              .or(Airpay.where(user_id: user.id).where(status: "審査中"))
            airpay_result1 = airpay_user.where(status: "審査完了").where(result_point: @airpay1_start_date..@airpay1_end_date)
            airpay_result1_max = airpay_result1.where(client: "マックス")
            airpay_result1_profit = 
              (airpay_result1.length * @airpay_price ) - 
              (airpay_result1_max.length * 2000)
            person_hash["AirPay第一成果件数"] = airpay_result1.length
            person_hash["AirPay現状売上"] = airpay_result1_profit


            # 終着
            # 26~末日に売上になった件数
            @airpay26_end_of_month_done_len = airpay_user.where(date: @start_date..@end_date).where(result_point: @start_date...@airpay1_start_date).where(status: "審査完了").length
            @airpay_period_result_len = airpay_user.where(date: @start_date..@end_date).where(status: "審査完了").length
            @airpay_prev_val_len = 
              Airpay.where(user_id: user.id)
              .where(status: "審査中")
              .where("? > date",@start_date).length
            airpay_len_fin = 
              (
                @result_airpay_sum.to_f / 
                person_hash["消化新規シフト"] * 
                person_hash["予定新規シフト"] *
                (@airpay1_this_month_per - @airpay_dec_per)
              ).round() rescue 0
            airpay_prev_len_fin = (@airpay_prev_val_len * (@airpay1_prev_month_per - @airpay_prev_dec_per)).round() rescue 0
            # 期間内
            airpay_period_fin = 
              (airpay_len_fin * @airpay_price) - 
              (@airpay_price * @airpay26_end_of_month_done_len) rescue 0
            # 過去
            airpay_prev_fin = (@airpay_price * airpay_prev_len_fin) + (@airpay_price * airpay_result1.where("? > date",@start_date).length) rescue 0
            airpay_maxsup = 
              airpay_user.where(client: "マックス").where(date: @start_date..@end_date) rescue 0
            airpay_maxsup_len = 
              airpay_maxsup.where(status: "審査完了")
              .or(
                airpay_maxsup.where(status: "審査中")

              ).length
            airpay_maxsup_len_fin = 
              (
                airpay_maxsup_len.to_f / 
              person_hash["消化新規シフト"] * 
              person_hash["予定新規シフト"] *
              (@airpay1_this_month_per - @airpay_dec_per)
              ).round() rescue 0
            airpay_result1_fin = 
              airpay_period_fin + airpay_prev_fin - (airpay_maxsup_len_fin * 2000) rescue 0
            if (airpay_result1_profit >= airpay_result1_fin) || (Date.today >= @closing_date)
              airpay_result1_fin = airpay_result1_profit
            end 
            
            person_hash["AirPay獲得数"] = @result_airpay_sum
            person_hash["AirPay終着獲得数"] = airpay_len_fin
            person_hash["AirPay終着獲得数（マックス）"] = airpay_maxsup_len_fin
            person_hash["AirPay一次成果終着"] = airpay_result1_fin
            person_hash["過去月審査中案件"] = @airpay_prev_val_len
            person_hash["過去月審査完了案件"] = airpay_result1.where("? > date",@start_date).length
            person_hash["前月中に成果になった件数"] = @airpay26_end_of_month_done_len
            person_hash["期間内成果率"] = ((@airpay1_this_month_per - @airpay_dec_per) * 100).round(1) 
            # person_hash["期間内計算式"] = "#{@result_airpay_sum - @airpay_period_result_len} / #{person_hash["消化新規シフト"]} * #{person_hash["予定新規シフト"]} * #{(@airpay1_this_month_per - @airpay_dec_per)}"
          # 出前館
            demaekan_user = Demaekan.where(user_id: user.id).where(status: "完了")
            # 一次成果
            demaekan_result1 = demaekan_user.where(first_cs_contract: @demaekan1_start_date..@demaekan1_end_date)
            demaekan_result1_profit = demaekan_result1.sum(:profit)
            person_hash["出前館第一成果件数"] = demaekan_result1.length
            person_hash["出前館現状売上"] = demaekan_result1_profit
            person_hash["出前館一次成果終着"] = demaekan_result1_profit
          # auステッカー
              au_sticker_user = OtherProduct.where(user_id: user.id).where(product_name: "auPay写真")
              au_sticker_result1 = au_sticker_user.where(date: @austicker1_start_date.. @austicker1_end_date)
              au_sticker_result1_profit = au_sticker_result1.sum(:profit)
              person_hash["auステッカー第一成果件数"] = au_sticker_result1.length
              person_hash["auステッカー現状売上"] = au_sticker_result1_profit
              person_hash["auステッカー一次成果終着"] = au_sticker_result1_profit
          # 現状売上
              # 新規
              profit_new = 
                person_hash["dメル現状売上1"] + person_hash["PayPay現状売上"] + person_hash["楽天ペイ現状売上"] +
                person_hash["AirPay現状売上"] + person_hash["出前館現状売上"] + person_hash["auステッカー現状売上"]
              person_hash["新規現状売上"] = profit_new
              # 決済
              profit_slmt = 
                person_hash["dメル現状売上2"] + person_hash["dメル現状売上3"] + person_hash["auPay現状売上1"]
              person_hash["決済現状売上"] = profit_slmt
              # 合計
                person_hash["合計現状売上"] = profit_new + profit_slmt
          # 終着売上
              # 新規
              profit_new_fin = 
                person_hash["dメル一次成果終着"] + person_hash["PayPay一次成果終着"] + person_hash["楽天ペイ一次成果終着"] +
                person_hash["AirPay一次成果終着"] + person_hash["出前館一次成果終着"] + person_hash["auステッカー一次成果終着"]
              person_hash["新規終着"] = profit_new_fin
              # 決済
              profit_slmt_fin = 
                person_hash["dメル二次成果終着"] + person_hash["dメル三次成果終着"] + person_hash["auPay一次成果終着"]
              person_hash["決済終着"] = profit_slmt_fin
              # 合計
                person_hash["合計終着"] = profit_new_fin + profit_slmt_fin
  
          # ハッシュへデータを配列へ格納
            if user.position != "退職"
              @all_list << person_hash
            end
            if (user.base_sub =="フェムト") && (user.position != "退職")
              @femto_list << person_hash
            elsif (user.base_sub =="サミット") && (user.position != "退職")
              @summit_list << person_hash
            elsif (base == "中部SS") && (user.position != "退職")
              @chubu_cash_list << person_hash
            elsif (base == "関西SS") && (user.position != "退職")
              @kansai_cash_list << person_hash
            elsif (base == "関東SS") && (user.position != "退職")
              @kanto_cash_list << person_hash
            elsif (base == "2次店") && (user.position != "退職")
              @partner_cash_list << person_hash
            elsif (user.position == "退職")
              @retire_list << person_hash
            end 
          end #ユーザーごとに繰り返す
        end # 拠点ごとに繰り返す
        @base_list = [@chubu_cash_list,@kansai_cash_list,@kanto_cash_list,@femto_list,@summit_list,@partner_cash_list,@retire_list]
    end 

end
