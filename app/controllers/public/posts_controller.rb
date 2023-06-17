class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:destroy]
  before_action :set_q, only: [:index, :search]
  before_action :ensure_guest_user, only: [:new]

  def new
    @post = Post.new
  end

  def create
    post = Post.new(post_params)
    post.user_id = current_user.id
    post.save
    redirect_to post_path(post.id)
  end

  def index
    @posts = Post.page(params[:page]).per(12).order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  def search
    @results = @q.result
  end

  private

    def post_params
      params.require(:post).permit(:title, :caption, :image)
    end

    def ensure_correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        redirect_to user_path(current_user)
      end
    end

    def set_q
      @q = Post.ransack(params[:q])
    end

    def ensure_guest_user
      if current_user.user_name == "guestuser"
        redirect_to posts_path , notice: 'ゲストユーザーは新規投稿できません。'
      end
    end
end
