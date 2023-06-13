class Admin::CommentsController < ApplicationController

  def destroy
    if current_user.user_name == "guestuser"
      redirect_to admin_users_path , notice: 'ゲスト管理者では管理者の権限を行使できません。'
    else
      Comment.find(params[:id]).destroy
      redirect_to admin_post_path(params[:post_id])
    end
  end

end
