# frozen_string_literal: true

require 'rails_helper'

RSpec.describe React, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:micropost) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:micropost_id) }
  it { should validate_presence_of(:action) }
end
