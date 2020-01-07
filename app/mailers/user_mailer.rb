# frozen_string_literal: true

class UserMailer < ActionMailer::Base
  default from: 'rubytesterofindia@gmail.com'

  def registration_confirmation(user)
    @user = user
    mail(to: user.email, subject: 'Registration Confirmation')
  end
end
