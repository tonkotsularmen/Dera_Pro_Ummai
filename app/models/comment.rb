class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy

  validates :comment, presence: true
  validate :maximum?
  #validates :comment, presence: true, length: { maximum: 120 }

  def maximum?
    if self.comment.size > 120
      self.errors.add(:comment, ": 120")
    end
  end
end
