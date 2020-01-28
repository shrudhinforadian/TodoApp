# frozen_string_literal: true

class User < ActiveRecord::Base
  before_create :confirmation_token
  has_secure_password
  # has_many :todos, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :todos, -> { distinct }, through: :shares
  validates :password_confirmation, presence: true, on: :create
  validates :password, confirmation: true, presence: true,
                       length: { minimum: 8 }, on: :create
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_uniqueness_of :email

  scope :user, ->(id) { where(id: id) }

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
  end


  private

  def confirmation_token
    return unless confirm_token.blank?

    self.confirm_token = SecureRandom.urlsafe_base64.to_s
  end
end
