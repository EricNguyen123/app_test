require 'rails_helper'

RSpec.describe RememberRoom, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:chat_room_id) }
end
