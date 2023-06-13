class Admin::PostsController < ApplicationController

  before_action :ensure_guest_user, only: [:destroy]

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    post = Post.find(params[:id])
    @user = post.user
    post.destroy
    redirect_to admin_user_path(@user)
  end

  private

    def ensure_guest_user
      if current_user.user_name == "guestuser"
        redirect_to admin_users_path , notice: 'ゲスト管理者は管理権限を行使できません。'
      end
    end

end