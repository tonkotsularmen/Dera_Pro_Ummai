class Post < ApplicationRecord
  has_one_attached :image

  belongs_to :user
  has_many   :comments,      dependent: :destroy
  has_many   :likes   ,      dependent: :destroy
  has_many   :notifications, dependent: :destroy
  has_many   :liked_users,     through: :likes,
                                source: :user

  validates  :image,          presence:  true
  validates  :title,          presence:  true, length: { maximum: 30 }
  validates  :caption,        presence:  true, length: { maximum: 150 }
  validate   :image_type

  def image_type
    if !image.blob.content_type.in?(%('image/jpeg image/png'))
      errors.add(:image, 'はjpegまたはpng形式でアップロードしてください')
    end
  end

  #validates :image,               format: { with: %r{.(gif|jpg|png)\Z}i, message: 'must be a URL for GIF, JPG or PNG image.' }
  #いいねしてるかどうか
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  #検索機能
  def self.looks(search,word)
    if search == "perfect_match"
      @post = Post.where("title LIKE?", "#{word}")
    elsif search == "forward_match"
      @post = Post.where("title LIKE?", "#{word}%")
    elsif search == "backward_match"
      @post = Post.where("title LIKE?", "%#{word}")
    elsif search == "partial_match"
      @post = Post.where("title LIKE?", "%#{word}%")
    else
      @post = Post.all
    end
  end

  #通知機能いいね
  # 関数に!ついているときは明示的に破壊的な処理を行っていることを一目でわかるようにするため。
  # 今回は関数内でデータ登録もしているので!をつけている
  def create_notification_like!(current_user) # => likes_controller.rb
    #すでにいいねされているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    # visitor_id にはcurrent_user.id、visited_id にはuser_id、post_id にはid、action にはlikeが入る
    # ?はプレースホルダーでSQLインジェクションを防ぐための、必須のセキュリティ
    #いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      #自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true # checkedはマイグレーションファイルでデフォルトでfalseにしてる
      end
      notification.save if notification.valid?
    end
  end

  #通知機能コメント # => comments_controller.rb
  def create_notification_comment!(current_user, comment_id)
    #自分以外にコメントしている人を全て取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    # 投稿にコメントしているユーザーIDを全て取得する=>自分のコメントは削除する=>重複したものは削除する
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    #まだ誰もコメントしてない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    #コメントは複数回することが考えられるため、一つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
