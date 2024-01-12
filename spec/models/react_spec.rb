require 'rails_helper'

RSpec.describe React, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:micropost) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:micropost_id) }
  it { should validate_presence_of(:action) }

  it do
    should validate_inclusion_of(:action).
      in_array(%w(like sad angry wow))
  end

  describe '.emotions' do
    it 'returns an array of emotions' do
      expect(React.emotions).to eq(%w(like sad angry wow))
    end
  end
end
