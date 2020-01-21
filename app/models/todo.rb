# frozen_string_literal: true

class Todo < ApplicationRecord
  # belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :users, :through => :shares
  has_many :shares, dependent: :destroy
  # validates :user_id, presence: true
  scope :sort_by_priority, -> { order(priority: :desc) }
  validates :body, presence: true,
                   length: { minimum: 8 }

  self.per_page = 5
  scope :select_by_active , -> (active) {where(active: active)}
  scope :search, ->(search) { where('body like ?', "%#{search}%") }


  private


end
