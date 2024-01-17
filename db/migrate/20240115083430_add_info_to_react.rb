# frozen_string_literal: true

# add columns
class AddInfoToReact < ActiveRecord::Migration[7.1]
  def change
    change_table :reacts, bulk: true do |t|
      t.integer :user_id
      t.integer :micropost_id
    end
    add_index :reacts, %i[user_id micropost_id], unique: true
  end
end
