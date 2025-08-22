class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for(@user)
      render :user, status: :created
    else
      Rails.logger.debug "Registration failed: #{@user.errors.full_messages.join(', ')}"
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email_address, :password, :password_confirmation)
  end
end
