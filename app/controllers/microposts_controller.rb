# frozen_string_literal: true

# Controller responsible for managing microposts.
class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user, only: :destroy
  def create
    if params[:micropost][:micropost_id]
      micropost = Micropost.find_by(id: params[:micropost][:micropost_id])
      @micropost = micropost.microposts.build(micropost_params)
    else
      @micropost = current_user.microposts.build(micropost_params)
    end
    @micropost.image.attach(params[:micropost][:image])

    if @micropost.save
      handle_micropost_save
      handle_comment_save(@micropost)
    else
      @feed_items = current_user.feed.without_micropost_id.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy!
    flash[:success] = 'Micropost deleted'
    redirect_to request.referrer || root_url
  end

  def update
    return unless params[:micropost][:id]

    micropost = Micropost.find_by(id: params[:micropost][:id])
    if micropost.update(micropost_params)
      @micropost = micropost
      @micropost.image.attach(params[:micropost][:image]) if params[:micropost][:image]
      # flash[:success] = 'Micropost updated!'
      # redirect_to root_url
      html_content = render_to_string(partial: 'shared/edit', locals: { comment: micropost }).squish
      render json: { success: true, micropost:, html_content: }
    end
  end

  private

  def handle_micropost_save
    return if params[:micropost][:micropost_id]

    flash[:success] = 'Micropost created!'
    redirect_to root_url
  end

  def handle_comment_save(micropost)
    return unless params[:micropost][:micropost_id]

    micropost = Micropost.find_by(id: micropost.micropost_id)
    html_content = render_to_string(partial: 'shared/reply', locals: { micropost: }).squish
    render json: { success: true, micropost:, html_content: }
  end

  def micropost_params
    params.require(:micropost).permit(:id, :content, :image, :micropost_id, :user_id)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
