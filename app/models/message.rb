class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  after_create_commit { broadcast_append_to(chat_room) }
  after_update_commit { broadcast_replace_to(chat_room) }
  after_destroy_commit { broadcast_remove_to(chat_room) }
end
