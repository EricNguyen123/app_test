# frozen_string_literal: true

# react emotion
class ReactsController < ApplicationController
  include ReactsHelper

  before_action :logged_in_user, only: %i[create destroy]

  def create
    @react = current_user.reacts.find_or_initialize_by(
      micropost_id: react_params[:micropost_id],
      user: current_user
    )

    @react.assign_attributes(action: react_params[:action])

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

  private

  def react_params
    params.require(:react).permit(:action, :micropost_id, :user_id)
  end
end
