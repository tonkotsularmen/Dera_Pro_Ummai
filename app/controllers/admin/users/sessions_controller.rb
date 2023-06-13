class Admin::Users::SessionsController < Devise::SessionsController

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to admin_users_path, notice: 'ゲスト管理者でログインしました。'
  end

end