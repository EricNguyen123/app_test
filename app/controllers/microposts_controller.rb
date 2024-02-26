# frozen_string_literal: true

# Controller responsible for managing microposts.
class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user, only: %i[destroy update]
  before_action :find_micropost, only: %i[show]
  def create
    @micropost = current_user.microposts.build(micropost_params)
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
    begin
      @micropost.destroy!
      flash[:success] = 'Micropost deleted'
    rescue ActiveRecord::RecordNotDestroyed
      flash[:error] = 'Micropost could not be deleted'
    end
    redirect_to request.referrer || root_url
  end

  def update
    return unless @micropost.update(micropost_params)

    html_content = render_to_string(partial: 'shared/edit', locals: { comment: @micropost }).squish
    render json: { success: true, micropost: @micropost, html_content: }
  end

  def show; end

  private

  def find_micropost
    @micropost = Micropost.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end

  def handle_micropost_save
    return if params[:micropost][:micropost_id]

    flash[:success] = 'Micropost created!'
    redirect_to root_url
  end

  def handle_comment_save(micropost)
    return unless params[:micropost][:micropost_id]

    html_content = render_to_string(partial: 'shared/reply', locals: { comment: micropost }).squish
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
