class Public::CommentsController < ApplicationController
  include Common
  before_action :ensure_guest_user

  def create
    @post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = @post.id
    if comment.save
      @post.create_notification_comment!(current_user, comment.id)
      @comments = @post.comments
      @comment = Comment.new
    else
      flash[:error]  = "コメントの送信に失敗しました。"
      redirect_to request.referer
    end

  end

  def show_create
    @post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = @post.id
    comment.save
    @post.create_notification_comment!(current_user, comment.id)
    @comments = @post.comments
    @comment = Comment.new
    redirect_to request.referer
  end

  def destroy
    Comment.find(params[:id]).destroy
    @post = Post.find(params[:post_id])
    @comments = @post.comments
  end


  private

    def comment_params
      params.require(:comment).permit(:comment)
    end

     # ゲストユーザーを弾く
    def ensure_guest_user
      if current_user.email == "guest@example.com"
        redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
      end
    end

end
