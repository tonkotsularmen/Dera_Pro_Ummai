class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many         :posts   , dependent: :destroy
  has_many         :comments, dependent: :destroy
  has_many         :likes   , dependent: :destroy

  has_many :active_relationships,  class_name: "Relationship",
                                  foreign_key: "follower_id",
                                    dependent: :destroy

  has_many :passive_relationships,  class_name: "Relationship",
                                   foreign_key: "followed_id",
                                     dependent: :destroy

  has_many :following,                through: :active_relationships,
                                       source: :followed

  has_many :followers,                through: :passive_relationships,
                                       source: :follower

  #自分から相手への通知
  has_many :active_notifications,  class_name: 'Notification',
                                  foreign_key: 'visitor_id',
                                    dependent: :destroy

  #自分が相手からの通知
  has_many :passive_notifications, class_name: 'Notification',
                                  foreign_key: 'visited_id',
                                    dependent: :destroy

  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
  validates :password    , format:       { with: VALID_PASSWORD_REGEX }, on: :create
  validates :user_name   , length:       { minimum: 1, maximum: 30 }, uniqueness: true
  validates :protein     , numericality: { in: 0..999 }
  validates :fat         , numericality: { in: 0..999 }
  validates :carbo       , numericality: { in: 0..999 }
  validates :introduction, length:       { maximum: 100 }
  validates :goal        , length:       { maximum: 50 }

  enum user_type: { トレーニー: 0, トレーナー: 1, サポーター: 2 }


  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  def get_profile_image
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end
    profile_image
  end

  #退会機能
  def active_for_authentication?
    super && (user_status == 1)
  end
  
  def self.looks(search,word)
    if search == "perfect_match"
      @user = User.where("user_name LIKE?", "#{word}")
    elsif search == "forword_match"
      @user = User.where("user_name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @user = User.where("user_name LIKE?", "%#{word}")
    elsif search == "partial_match"
      @user = User.where("user_name LIKE?", "%#{word}%")
    else 
      @user = User.all
    end 
  end 

  #ゲストログイン
  def self.guest
    find_or_create_by!(user_name: 'guestuser' ,email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end

  # ユーザーのステータスフィードを返す
  def feed
    #Post.where("user_id IN (?) OR user_id = ?",
    #                      following_ids,        id)
    #Post.where("user_id IN (:following_ids) OR user_id = :user_id",
    #                           following_ids: following_ids, user_id: id)
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Post.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end


  #フォロー時の通知
  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow' ])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

end

