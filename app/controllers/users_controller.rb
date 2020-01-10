# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authorize
  # creating new user
  def index
    redirect_to login_url
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.registration_confirmation(@user).deliver_now
      flash[:success] = 'Please confirm your email address to continue'
      redirect_to signup_url
    else
      flash[:danger] = 'Sorry You Cannot Sign in'
      render 'new'
    end
  end

  def new
    @user = User.new
  end

  # confirming email
  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      session[:user_id] = nil
      flash[:success] = "Welcome to the Blog Your email has been confirmed.
        Please sign in to continue."
      redirect_to login_url
    else
      flash[:warning] = 'Sorry. User does not exist'
      redirect_to root_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
