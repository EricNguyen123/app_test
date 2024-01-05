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
      flash[:success] = 'Micropost created!'
      redirect_to root_url unless params[:micropost][:micropost_id]
      if params[:micropost][:micropost_id]
        micropost = Micropost.find_by(id: @micropost.micropost_id)
        html_content = render_to_string(:partial => 'shared/reply', :locals => { :micropost => micropost }).squish
        render json: { success: true, micropost: @micropost, html_content: html_content } 
      end
    else
      @feed_items = current_user.feed.where(micropost_id: nil).paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy!
    flash[:success] = 'Micropost deleted'
    redirect_to request.referrer || root_url
  end

  def update
    if params[:micropost][:id]
      micropost = Micropost.find_by(id: params[:micropost][:id])
      @micropost = micropost.update(micropost_params)
      @micropost.image.attach(params[:micropost][:image]) if params[:micropost][:image]
      flash[:success] = 'Micropost updated!'
      redirect_to root_url
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:id, :content, :image, :micropost_id, :user_id)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
