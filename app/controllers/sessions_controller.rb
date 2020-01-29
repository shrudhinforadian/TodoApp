# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authorize

  def index
    redirect_to login_url
  end

  def new; end
  # creating new user object

  def create
    user = User.find_by_email(params[:email].downcase)
    return unless user.email_confirmed

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to :todos, flash: { success: 'Successfully Logged in' }
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  # log outing the current_user
  def destroy
    session[:user_id] = nil
    redirect_to sessions_path, flash: { info: 'Logged Out' }
  end
end
