class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  
  def destroy
      Comment.find(params[:id]).destroy
      redirect_to admin_post_path(params[:post_id])
  end

end
