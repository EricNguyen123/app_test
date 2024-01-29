# frozen_string_literal: true

# add AddOauthTokenToUsers
class AddOauthTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :oauth_token, :text
  end
end
