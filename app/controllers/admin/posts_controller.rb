class Admin::PostsController < ApplicationController


  def show
    @post = Post.find(params[:id])
  end

  def destroy
    post = Post.find(params[:id])
    @user = post.user
    post.destroy
    redirect_to admin_user_path(@user)
  end


end