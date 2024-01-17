# frozen_string_literal: true

# react model
class React < ApplicationRecord
  belongs_to :user
  belongs_to :micropost

  validates :user_id, uniqueness: { scope: :micropost_id }
  validates :action, presence: true
  enum action: { like: 0, sad: 1, angry: 2, wow: 3 }
end
