class AddMicropostToReact < ActiveRecord::Migration[7.1]
  def change
    add_column :reacts, :micropost_id, :string
  end
end
