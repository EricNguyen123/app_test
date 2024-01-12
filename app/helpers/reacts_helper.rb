# frozen_string_literal: true

# react helper
module ReactsHelper
  def emotions
    @item_reacts = [
      { emotion: 'like', image: 'like.svg' },
      { emotion: 'angry', image: 'angry.svg' },
      { emotion: 'sad', image: 'sad.svg' },
      { emotion: 'wow', image: 'wow.svg' }
    ]
  end

  def btn_item
    @btn_item = 'like_react_btn.svg'
  end
end
