module ApplicationHelper

  #投稿時間を表示する
  def post_time(apost)
    today = Date.today #今日の日付を取得
    now = Time.now     #現在時刻を取得
    if (now - apost.created_at) <= 60 * 60                   #もし、現在時刻-投稿時間が3600秒(60分)以下なら
      ((now - apost.created_at) / 60).to_i.to_s + "分前"     #分前と表示
    elsif (now - apost.created_at) <= 60 * 60 * 24           #もし、現在時刻-投稿時間が86400秒(24時間)以下なら
      ((now - apost.created_at) / 3600).to_i.to_s + "時間前" #時間前と表示
    elsif (today - apost.created_at.to_date) <= 30           #もし、現在時刻-投稿時間が30日以下なら
      (today - apost.created_at.to_date).to_i.to_s + "日前"  #日前と表示
    else                                                      #それ以外なら
      t.created_at.strftime('%Y-%m-%d')                       #投稿時間を表示
    end
  end
 
end
