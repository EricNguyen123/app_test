# frozen_string_literal: true

# add user id
class AddUserToReact < ActiveRecord::Migration[7.1]
  def change
    add_column :reacts, :user_id, :string
  end
end
