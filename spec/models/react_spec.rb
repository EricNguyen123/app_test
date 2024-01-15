# frozen_string_literal: true

require 'rails_helper'

RSpec.describe React, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:micropost) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:micropost_id) }
  it { should validate_presence_of(:action) }

  describe '.emotions' do
    it 'returns an array of emotions' do
      expect(React.emotions).to eq(%w[like sad angry wow])
    end
  end

  describe '.enum_reacts' do
    it 'returns the correct enum mapping for actions' do
      expected_enum_mapping = { 'like' => 0, 'sad' => 1, 'angry' => 2, 'wow' => 3 }
      expect(React.enum_reacts).to eq(expected_enum_mapping)
    end
  end
end
