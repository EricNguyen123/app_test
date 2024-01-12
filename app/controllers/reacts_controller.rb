class ReactsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :set_micropost, only: %i[create destroy]

  def create
    return render json: { success: false, status: 'error' } if React.find_by(user_id: params[:react][:user_id], micropost_id: params[:react][:micropost_id])
    
    @react = @micropost.reacts.new(react_params)
    @react.user_id = params[:react][:user_id]
    if @react.save
      html_content = render_to_string(partial: 'reacts/remove_action', locals: { emotion: @react.action, micropost: @micropost }).squish
      html_total_react = render_to_string(partial: 'reacts/total_react', locals: { micropost: @micropost }).squish
      render json: { success: true, emotion: @react, status: 'success', html_content:, html_total_react: }
    else
      render json: { success: false, status: 'error' }
    end
  end

  def destroy
    @react = @micropost.reacts.find_by(id: params[:react][:id])
    if @react && @react.destroy
      html_content = render_to_string(partial: 'reacts/perform_action', locals: { micropost: @micropost, emotion: params[:react][:action] }).squish
      html_cancel = render_to_string(partial: 'reacts/image_check_icon', locals: { micropost: @micropost }).squish
      html_total_react = render_to_string(partial: 'reacts/total_react', locals: { micropost: @micropost }).squish
      render json: { success: true, status: 'success', html_content:, html_cancel:, html_total_react: }
    else
      render json: { success: false, status: 'error' }
    end
  end

  private

  def set_micropost
    redirect_to root_url unless params[:react].present?
    @micropost = Micropost.find(params[:react][:micropost_id])
  end

  def react_params
    params.require(:react).permit( :id, :action, :micropost_id, :user_id)
  end
end
