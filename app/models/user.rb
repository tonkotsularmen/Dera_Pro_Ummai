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

  enum user_type: { トレーニー: 0, トレーナー: 1, サポーター: 2 }

  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
  validates :password    , format:       { with: VALID_PASSWORD_REGEX }, on: :create
  validates :user_name   , length:       { minimum: 1, maximum: 30 }, uniqueness: true
  validates :protein     , numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 500 }
  validates :fat         , numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 500 }
  validates :carbo       , numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 500 }
  validates :introduction, length:       { maximum: 100 }
  validates :goal        , length:       { maximum: 50 }

  validate   :profile_image_type

  def profile_image_type
    if profile_image.blob != nil
      if !profile_image.blob.content_type.in?(%('image/jpeg image/png'))
        errors.add(:profile_image, 'はjpegまたはpng形式でアップロードしてください')
      end
    end
  end

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'macho3.jpeg'
  end

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

  #退会機能
  def active_for_authentication?
    super && (user_status == 1)
  end

  #検索機能
  def self.looks(search,word)
    if search == "perfect_match"
      @user = User.where("user_name LIKE?", "#{word}")
    elsif search == "forward_match"
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
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.user_name = "guestuser"
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

