class CreateChatRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_rooms do |t|
      t.string :title

      t.timestamps
    end
  end
end
