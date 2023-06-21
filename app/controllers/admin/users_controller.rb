class Admin::UsersController < ApplicationController
   before_action :authenticate_admin!

  def index
    @users = User.page(params[:page])
    @all_users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
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
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "情報が更新されました"
      redirect_to admin_user_path(@user.id)
    else
      flash[:notice] = "情報の更新に失敗しました"
      redirect_to edit_admin_user_path(@user)
    end
  end

  def unsubscribe
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = 'ユーザーを削除しました。'
    redirect_to admin_users_path
  end

private

    def user_params
      params.require(:user).permit(:user_name, :email, :introduction, :profile_image, :goal, :protein, :fat, :carbo, :user_status)
    end

end
