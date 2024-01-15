# frozen_string_literal: true

# add columns
class AddInfoToReact < ActiveRecord::Migration[7.1]
  def change
    change_table :reacts, bulk: true do |t|
      t.integer :user_id
      t.integer :micropost_id
    end
    # add_column :reacts, :user_id, :integer
    # add_column :reacts, :micropost_id, :integer
  end
end
