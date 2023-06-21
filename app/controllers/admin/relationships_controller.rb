class Admin::RelationshipsController < ApplicationController
  
  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    user.create_notification_follow!(current_user)
    @user = User.find(params[:user_id])
    @post = @user.posts
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    @user = User.find(params[:user_id])
    @post = @user.posts
  end
  
end
