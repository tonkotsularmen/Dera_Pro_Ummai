class Admin::UsersController < ApplicationController

  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @post = @user.posts
  end

  def destroy
    if current_user.user_name == "guestuser"
      redirect_to admin_users_path , notice: 'ゲスト管理者では管理者の権限を行使できません。'
    else
      @user = User.find(params[:id])
      @user.destroy
      flash[:notice] = 'ユーザーを削除しました。'
      redirect_to admin_users_path
    end 
  end

end
