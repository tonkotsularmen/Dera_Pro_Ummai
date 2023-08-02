module Common
  extend ActiveSupport::Concern

  # メソッド

  def best_likes_posts
    to  = Time.current.at_end_of_day #Timeクラスにcurrentメソッドから、その日の終わりの23:59:59.999999999をtoに代入
    from  = (to - 6.day).at_beginning_of_day#Sun, 18 Jun 2023 00:00:00.000000000をfromに代入
    best_likes_posts = Post.left_joins(:likes).where(likes: {created_at: from...to}).group(:id).order("count(likes.post_id) desc")
    # postテーブルとlikesテーブルを左外部結合して指定したモデルのデータを取得する
    # left_joinsで左外部結合するときにwhereで条件を指定している。
    # ここで取得するのはPostのデータのみ
    # モデル名.left_joins(:関連名).where(結合先のテーブル名: {カラム名: 値})
    # best_likes_posts = Post.includes(:liked_users).
      # sort {|a,b|
      #   b.liked_users.includes(:likes).where(created_at: from...to).size <=>
      #   a.liked_users.includes(:likes).where(created_at: from...to).size
      # }
    return best_likes_posts
  end

  def search
    @range = params[:range]#検索範囲をフォームから受け取る

    if @range == "ユーザー"
      @users = User.looks(params[:search], params[:word])
    else                  # 検索方法         検索ワード
      @posts = Post.looks(params[:search], params[:word])
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

end