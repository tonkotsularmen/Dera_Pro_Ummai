class Public::UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @post = @user.posts
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to user_path(user.id)
  end


  private

    def user_params
      params.require(:user).permit(:user_name, :email, :profile_image, :goal, :protein, :fat, :carbo)
    end

end
