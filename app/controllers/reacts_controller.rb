# frozen_string_literal: true

# react emotion
class ReactsController < ApplicationController
  include ReactsHelper

  before_action :logged_in_user, only: %i[create destroy]

  def create
    react_update

    if @react.save
      html_content = render_to_string(partial: 'reacts/remove_action', locals: { emotion: @react.action }).squish
      html_total_react = render_to_string(partial: 'reacts/total_react', locals: { react: @react }).squish
      render json: { success: true, emotion: @react, status: 'success', html_content:, html_total_react: }
    else
      render json: { success: false, status: 'error' }
    end
  end

  def destroy
    @react = current_user.reacts.find_by(react_params)
    if @react&.destroy
      html_cancel = render_to_string(partial: 'reacts/image_handle_icon').squish
      html_total_react = render_to_string(partial: 'reacts/total_react', locals: { react: @react }).squish
      render json: { success: true, status: 'success', html_cancel:, html_total_react: }
    else
      render json: { success: false, status: 'error' }
    end
  end

  def react_update
    return @react = current_user.reacts.new(react_params) unless react_exists?

    @react = react_exists?
    render json: { success: false, status: 'error' } unless @react.update(react_params)
  end

  private

  def react_params
    params.require(:react).permit(:action, :micropost_id, :user_id)
  end

  def react_exists?
    current_user.reacts.find_by(micropost_id: params[:react][:micropost_id])
  end
end
