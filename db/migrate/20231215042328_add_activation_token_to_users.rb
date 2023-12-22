class AddActivationTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :activation_tocken, :string
  end
end
