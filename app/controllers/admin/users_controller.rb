class Admin::UsersController < ApplicationController
  include Common
   before_action :authenticate_admin!
   before_action :set_user, except: [:index, :unsubscribe ]

  def index
    @users = User.page(params[:page])
    @all_users = User.all
  end

  def show
    @posts = @user.posts.order(created_at: :desc)
  end

  def following #ユーザーがフォローしているユーザー
    @users = @user.following
    render 'show_follow'
  end

  def followers #ユーザーをフォローしているユーザー
    @users = @user.followers
    render 'show_follow'
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "情報が更新されました"
      redirect_to admin_user_path(@user.id)
    else
      flash[:notice] = "情報の更新に失敗しました"
      redirect_to edit_admin_user_path(@user)
    end
  end

  def unsubscribe #退会確認画面
  end

  def destroy
    @user.destroy
    flash[:notice] = 'ユーザーを削除しました。'
    redirect_to admin_users_path
  end
  
  private

    def user_params
      params.require(:user).permit(:user_name, :email, :introduction, :profile_image, :goal, :protein, :fat, :carbo, :user_status)
    end
    
    
end
