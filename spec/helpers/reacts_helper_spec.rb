require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ReactsHelper. For example:
#
# describe ReactsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ReactsHelper, type: :helper do
  describe '#emotions' do
    it 'returns an array of emotions' do
      expect(helper.emotions).to eq([
        { emotion: 'like', image: 'like.svg' },
        { emotion: 'angry', image: 'angry.svg' },
        { emotion: 'sad', image: 'sad.svg' },
        { emotion: 'wow', image: 'wow.svg' },
      ])
    end
  end

  describe '#btnItem' do
    it 'returns the like react button image' do
      expect(helper.btnItem).to eq('like_react_btn.svg')
    end
  end
end
