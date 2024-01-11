# frozen_string_literal: true

# model micropost
class Micropost < ApplicationRecord
  belongs_to :user
  has_many :reacts
  has_many :microposts, dependent: :destroy
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  scope :without_micropost_id, -> { where(micropost_id: nil) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :image_content_type
  validate :image_size
  def image_content_type
    return unless image.attached? && !image.content_type.in?(%w[image/jpeg image/gif image/png])

    errors.add(:image, 'must be a valid image format')
  end

  def image_size
    return unless image.attached? && image.blob.byte_size > 5.megabytes

    errors.add(:image, 'should be less than 5MB')
  end

  def display_image
    image.variant(resize_to_limit: [500, 500]).processed
  end
end
