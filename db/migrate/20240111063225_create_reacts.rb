# frozen_string_literal: true

# create reaction
class CreateReacts < ActiveRecord::Migration[7.1]
  def change
    create_table :reacts do |t|
      t.integer :action

      t.timestamps
    end
  end
end
