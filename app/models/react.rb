class React < ApplicationRecord
  belongs_to :user
  belongs_to :micropost

  validates :user_id, presence: true
  validates :micropost_id, presence: true
  validates :action, presence: true, inclusion: { in: %w(like sad angry wow) }

  def self.emotions
    %w(like sad angry wow)
  end
end
