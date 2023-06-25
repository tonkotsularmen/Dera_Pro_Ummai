class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  include Common
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
    @best_likes_posts = best_likes_posts.first(5) #common.rbに記述
  end

  def destroy
    post = Post.find(params[:id])
    @user = post.user
    post.destroy
    redirect_to admin_user_path(@user)
  end

end