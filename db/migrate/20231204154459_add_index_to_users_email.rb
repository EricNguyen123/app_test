# frozen_string_literal: true

# add index email
class AddIndexToUsersEmail < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :email, unique: true
  end
end
