class AddCommentIdToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :comment_id, :string
  end
end
