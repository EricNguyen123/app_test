# frozen_string_literal: true

module Api
  module V1
    class MicropostsController < ApplicationController
      before_action :authenticate_user!
      before_action :logged_in_user, only: %i[create destroy]
      before_action :correct_user, only: %i[destroy update]
      before_action :find_micropost, only: %i[show]
      skip_before_action :verify_authenticity_token
      def index
        @microposts = Micropost.all
        render json: @microposts, status: 200
      end

      def create
        @micropost = current_user.microposts.build(micropost_params)
        @micropost.image.attach(params[:micropost][:image])
        if @micropost.save
          render json: @micropost, status: 200
        else
          @feed_items = current_user.feed.without_micropost_id.paginate(page: params[:page])
          render json: {
            data: @feed_items,
            messages: 'Error save'
          }
        end
      end

      def destroy
        @micropost.destroy!
        flash[:success] = 'Micropost deleted'
        render json: {
          messages: 'Success destroy',
          status: 200
        }
      rescue ActiveRecord::RecordNotDestroyed
        flash[:error] = 'Micropost could not be deleted'
        render json: {
          messages: 'Error destroy',
          status: 400
        }
      end

      def update
        return render json: { messages: 'Error update', status: 400 } unless @micropost.update(micropost_params)

        render json: @micropost, status: 200
      end

      def show; end

      private

      def find_micropost
        @micropost = Micropost.find_by(id: params[:id])
        if @micropost.nil?
          render json: {
            messages: 'Not found',
            status: 400
          }
        else
          render json: @micropost, status: 200
        end
      end

      def micropost_params
        params.require(:micropost).permit(:id, :content, :image, :micropost_id, :user_id)
      end

      def correct_user
        @micropost = Micropost.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
      end
    end
  end
end
