class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  after_create_commit { broadcast_append_to('messages') }
  after_destroy_commit { broadcast_remove_to('messages') }
end
