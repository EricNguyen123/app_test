class AddInfoToMessages < ActiveRecord::Migration[7.1]
  def change
    change_table :messages, bulk: true do |t|
      t.integer :user_id
      t.integer :chat_room_id
    end
  end
end
