# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Remember, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:chat_room_id) }
end
