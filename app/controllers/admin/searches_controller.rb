class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!
  
  
  def search
    @range = params[:range]#検索範囲をフォームから受け取る

    if @range == "ユーザー"
      @users = User.looks(params[:search], params[:word])
    else                  # 検索方法         検索ワード
      @posts = Post.looks(params[:search], params[:word])
    end
  end

end
