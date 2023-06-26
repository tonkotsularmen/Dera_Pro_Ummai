class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!

  def destroy
    Comment.find(params[:id]).destroy
    flash[:notice] = "コメントの削除に成功しました"
    redirect_to admin_post_path(params[:post_id])
  end

end
