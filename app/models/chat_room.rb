class ChatRoom < ApplicationRecord
  validates_uniqueness_of :title
  after_create_commit { broadcast_if_public }

  def broadcast_if_public
    broadcast_append_to 'chat_rooms'
  end
end
