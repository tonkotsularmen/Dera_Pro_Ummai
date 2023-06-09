class Public::UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end 
  
  def edit
    user = User.new(user_params)
    user.save
    redirect_to user_path(user.id)
  end
  
  def update
  end 
  
  
  private
  
    def user_params
      params.require(:users).permit(:user_name, :email, :goal, :protein, :fat, :carbo)
    end 
end
