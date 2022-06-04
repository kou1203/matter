class CommentsController < ApplicationController
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

  private 
  def comment_params 
    params.require(:comment).permit(
      :store_prop_id         ,
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
