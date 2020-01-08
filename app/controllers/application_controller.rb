# frozen_string_literal: true

class ApplicationController < ActionController::Base

  before_action :authorize
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  def record_not_found
    render plain: '404 Not Found', status: 404
  end

  private
  #identifying the current logged in user
  def current_user

    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def authorize

    redirect_to login_url if current_user.nil?
    # current_user
  end
end
