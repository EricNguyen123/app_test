# frozen_string_literal: true

# db messages
class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :message

      t.timestamps
    end
  end
end
