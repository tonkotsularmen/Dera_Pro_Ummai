class Public::PostsController < ApplicationController

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
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def destroy
    
  end

  private
  
    def post_params
      params.require(:post).permit(:title, :caption, :image)
    end
end
