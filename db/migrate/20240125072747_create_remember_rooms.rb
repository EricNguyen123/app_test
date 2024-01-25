class CreateRememberRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :remember_rooms do |t|
      t.integer :user_id
      t.integer :chat_room_id

      t.timestamps
    end
    add_index :remember_rooms, %i[user_id chat_room_id], unique: true
  end
end
