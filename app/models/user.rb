class User < ActiveRecord::Base
  before_create :confirmation_token

  has_secure_password
  scope :user, ->(id) { where(id: id) }
  has_many :todos, dependent: :destroy
  validates :password_confirmation, presence: true, on: :create
  validates :password, confirmation: true, presence: true,
                       length: { minimum: 8 }, on: :create
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_uniqueness_of :email
  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
end

  private

  def confirmation_token
    if confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
      end
end
