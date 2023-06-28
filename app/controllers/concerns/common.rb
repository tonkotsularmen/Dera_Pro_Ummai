module Common
  extend ActiveSupport::Concern

  # メソッド

  def best_likes_posts
    to  = Time.current.at_end_of_day #Sat, 24 Jun 2023 23:59:59.999999999をtoに代入
    from  = (to - 6.day).at_beginning_of_day#Sun, 18 Jun 2023 00:00:00.000000000をfromに代入
    best_likes_posts = Post.includes(:liked_users).
      sort {|a,b|
        b.liked_users.includes(:likes).where(created_at: from...to).size <=>
        a.liked_users.includes(:likes).where(created_at: from...to).size
      }
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

end