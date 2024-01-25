# frozen_string_literal: true

# db remmember
class CreateRemembers < ActiveRecord::Migration[7.1]
  def change
    create_table :remembers do |t|
      t.integer :user_id
      t.integer :chat_room_id

      t.timestamps
    end
    add_index :remembers, [:user_id, :chat_room_id], unique: true
  end
end
