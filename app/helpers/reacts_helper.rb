module ReactsHelper
  def emotions
    @item_reacts = [
      { emotion: 'like', image: 'like.svg' },
      { emotion: 'angry', image: 'angry.svg' },
      { emotion: 'sad', image: 'sad.svg' },
      { emotion: 'wow', image: 'wow.svg' },
    ]
  end

  def btnItem
    @btnItem = 'like_react_btn.svg'
  end
end
