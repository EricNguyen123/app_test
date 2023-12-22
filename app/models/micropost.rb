class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :image_content_type
  validate :image_size
  def image_content_type
    if image.attached? && !image.content_type.in?(%w[image/jpeg image/gif image/png])
      errors.add(:image, "must be a valid image format")
    end
  end
  def image_size
    if image.attached? && image.blob.byte_size > 5.megabytes
      errors.add(:image, "should be less than 5MB")
    end
  end
  def display_image 
    image.variant(resize_to_limit: [500, 500]).processed
  end
end
