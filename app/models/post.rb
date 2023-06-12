class Post < ApplicationRecord
  has_one_attached :image

  belongs_to :user
  has_many   :comments, dependent: :destroy
  has_many   :likes   , dependent: :destroy

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["title", "caption",]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "user_name"]
  end

end
