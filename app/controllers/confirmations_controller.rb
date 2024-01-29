# frozen_string_literal: true

# controller account activations
class ConfirmationsController < Devise::ConfirmationsController
  
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      user = User.find_by(email: resource.email)
      user.activate
      sign_in(user)
      flash[:success] = 'Account activated!'
      redirect_to user
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
  end

  
  private

  def after_confirmation_path_for(_resource_name, resource)
    sign_in(resource)
    root_path
  end
end
