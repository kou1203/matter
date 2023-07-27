class CommentsController < ApplicationController

  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    if params[:product].present? 
      @comments = Comment.includes(:store_prop).where(product: params[:product])
    else
      @comments = Comment.includes(:store_prop).all
    end 
  end 

  def new 
    @store_id = params[:store_id]
    @product = params[:product]
    @content = params[:content]
    @comment = Comment.new
    session[:previous_url] = request.referer
  end 

  def create 
    @comment = Comment.new(comment_params)
    @product = @comment.product
    @store_id = @comment.store_prop_id
    if @comment.save
      flash[:notice] = "対応結果を登録しました。"
      redirect_to session[:previous_url]
    else  
      render :new
    end
  end 

  def edit 
    @comment = Comment.find(params[:id])
    session[:previous_url] = request.referer
  end 

  def update 
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    flash[:notice] = "対応結果を更新しました。"
    redirect_to session[:previous_url]
  end 


  def destroy 
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to comments_path, alert: "#{@comment.store_prop.name}の対応依頼を情報を削除しました。"
  end 

  private 
  def comment_params 
    params.require(:comment).permit(
      :store_prop_id      ,
      :product            ,
      :content            ,
      :status             ,
      :ball               ,
      :request            ,
      :request_show       ,
      :response           ,
      :response_show      ,
      :done     
    )
  end 
end
