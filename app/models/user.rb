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

  validates :protein, numericality: { in: 0..999 }
  validates :fat, numericality: { in: 0..999 }
  validates :carbo, numericality: { in: 0..999 }


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

  def self.ransackable_attributes(auth_object = nil)
    ["goal","user_name"]
  end
end

