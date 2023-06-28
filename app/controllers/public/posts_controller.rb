class Public::PostsController < ApplicationController
  include Common
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:destroy]
  before_action :ensure_guest_user, only: [:new]

  def new
    @post = Post.new
  end

  def shokuyoku_new 
    @yabai = Post.new(title: "食欲がやばいです", caption:"食欲がやばいです。どう対処したらいいですか？")
  end

  def zasetsu_new
    @zasetsu = Post.new(title: "やりたくなーい！！", caption:"やる気が起きません！！鼓舞してくれませんか！？")
  end

  def create
    @post            = Post.new(post_params)
    @yabai           = Post.new(post_params) #食欲やばい投稿
    @zasetsu         = Post.new(post_params) #やりたくない投稿
    @post.user_id    = current_user.id
    @yabai.user_id   = current_user.id       #食欲やばい投稿
    @zasetsu.user_id = current_user.id       #やりたくない投稿

    if @post.save || @yabai.save || @zasetsu.save
      flash[:notice] = "投稿が成功しました"
      redirect_to post_path(@post.id)
    else
      flash[:error]  = "投稿が失敗しました"
      redirect_to users_path
    end

  end

  def index
    posts = Post.includes(:user).page(params[:page]).per(16)
    @posts= posts.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
    @best_likes_posts = best_likes_posts.first(5) #common.rbに記述
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    flash[:error] = "投稿を削除しました"
    redirect_to users_path
  end

  private

    def post_params
      params.require(:post).permit(:title, :caption, :image)
    end

    # レコードのユーザーと現在のユーザーの比較
    def ensure_correct_user
      @post = Post.find(params[:id])
      unless @post.user == current_user
        redirect_to posts_path
      end
    end

    # ゲストユーザーを弾く
    def ensure_guest_user
      if current_user.user_name == "guestuser"
        redirect_to posts_path , notice: 'ゲストユーザーは新規投稿できません。'
      end
    end


end
