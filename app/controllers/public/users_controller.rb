class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :unsubscribe, :withdrawal]
  before_action :ensure_guest_user, only: [:edit]
  before_action :set_user, except: [:index, :update, :unsubscribe ]

  def index
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    best_likes_posts = Post.includes(:liked_users).
      sort {|a,b|
        b.liked_users.includes(:likes).where(created_at: from...to).size <=>
        a.liked_users.includes(:likes).where(created_at: from...to).size
      }
    @best_likes_posts = best_likes_posts.first(5)
    @posts = current_user.feed.order(created_at: :desc)
    @users = current_user.following
    @comment = Comment.new
  end

  def show
    @posts = @user.posts.order(created_at: :desc)
  end

  def following
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @users = @user.followers
    render 'show_follow'
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user
      if @user.update(user_params)
        flash[:notice] = "情報が更新されました"
        redirect_to user_path(@user.id)
      else
        flash[:error] = "情報の更新に失敗しました"
        redirect_to edit_user_path(@user)
      end
    else
      redirect_to user_path(@user)
    end
  end

  def likes
    likes = Like.where(user_id: @user.id).pluck(:post_id)
    @like_posts = Post.find(likes)
  end

  def unsubscribe
  end

  def withdrawal
    @user.update(user_status: 0)
    reset_session
    flash[:erro] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  private

    def user_params
      params.require(:user).permit(:user_name, :email, :introduction, :profile_image, :goal, :protein, :fat, :carbo, :user_type)
    end

    def ensure_correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        redirect_to user_path(current_user)
      end
    end

    def ensure_guest_user
      @user = User.find(params[:id])
      if @user.user_name == "guestuser"
        redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
      end
    end

    def set_user
      @user = User.find(params[:id])
    end

end
