class AddUserToReact < ActiveRecord::Migration[7.1]
  def change
    add_column :reacts, :user_id, :string
  end
end
