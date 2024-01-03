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
      redirect_to root_url
    else
      @feed_items = current_user.feed.where(micropost_id: nil).paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    delete_cmt(@micropost.id)
    @micropost.destroy!
    flash[:success] = 'Micropost deleted'
    redirect_to request.referrer || root_url
  end

  private

  def delete_cmt(cmt_id)
    until Micropost.find_by(id: cmt_id).nil?
      if !Micropost.find_by(micropost_id: cmt_id).nil?
        delete_cmt(Micropost.find_by(micropost_id: cmt_id).id)
      else
        Micropost.find_by(id: cmt_id).destroy!
      end
    end
  end

  def micropost_params
    params.require(:micropost).permit(:content, :image, :micropost_id, :user_id)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
