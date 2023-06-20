class Admin::UsersController < ApplicationController
   before_action :authenticate_admin!

   
  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end
  
  def following
    @user = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  def edit
  end
  
  def unsubscribe
  end
  
  def destroy
      @user = User.find(params[:id])
      @user.destroy
      flash[:notice] = 'ユーザーを削除しました。'
      redirect_to admin_users_path
  end

end
