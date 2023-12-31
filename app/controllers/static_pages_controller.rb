# frozen_string_literal: true

# Controller managing user static page.
class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.without_micropost_id.paginate(page: params[:page], per_page: 6)
  end

  def help; end

  def about; end

  def contact; end
end
