class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:destroy]
  before_action :set_q, only: [:index, :search]
  before_action :ensure_guest_user, only: [:new]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿が成功しました"
      redirect_to post_path(post.id)
    else
      redirect_to new_post_path, flash: { error: @post.errors.full_messages }
    end
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
    redirect_to users_path
  end

  def search
    @results = @q.result
  end

  private

    def post_params
      params.require(:post).permit(:title, :caption, :image)
    end

    def ensure_correct_user
      @post = Post.find(params[:id])
      unless @post.user == current_user
        redirect_to posts_path
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
