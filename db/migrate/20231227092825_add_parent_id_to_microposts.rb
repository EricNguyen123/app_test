# frozen_string_literal: true

# add parent id to micropost
class AddParentIdToMicroposts < ActiveRecord::Migration[7.1]
  def change
    add_column :microposts, :micropost_id, :string
  end
end
