class DmerMemosController < ApplicationController
  def new
    @dmer_senbai = DmerSenbai.find(params[:dmer_senbai_id])
    @dmer_memo = DmerMemo.new
    session[:previous_url] = request.referer
  end
  
  def create
    @dmer_senbai = DmerSenbai.find(params[:dmer_senbai_id])
    @dmer_memo = DmerMemo.new(dmer_memo_params)
    if @dmer_memo.save
      redirect_to session[:previous_url]
    else
      render :new 
    end
  end

  def edit
    @dmer_senbai = DmerSenbai.find(params[:dmer_senbai_id])
    @dmer_memo = DmerMemo.find(params[:id])
    session[:previous_url] = request.referer
  end

  def update
    @dmer_senbai = DmerSenbai.find(params[:dmer_senbai_id])
    @dmer_memo = DmerMemo.find(params[:id])

    if @dmer_memo.update(dmer_memo_params)
      redirect_to session[:previous_url]
    else
      render :edit
    end
  end

  private

  def dmer_memo_params 
    params.require(:dmer_memo).permit(:dmer_senbai_id, :memo, :status, :date)
  end
end
