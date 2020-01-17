# frozen_string_literal: true

class Todo < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :shares, dependent: :destroy
  validates :user_id, presence: true
  validates :body, presence: true,
                   length: { minimum: 8 }

  self.per_page = 5
  scope :select_by_active , -> (active) {where(active: active)}
  scope :sort_by_priority, -> { order(priority: :desc) }
  scope :search, ->(search) { where('body like ?', "%#{search}%") }

  def priority_switch(symbol, todos)
    up = symbol == 'up' ? todos.where("priority > ?", priority).last
     : todos.where("priority < ?", priority).first
    priority_temp = priority
    change_priority(up.priority)
    up.change_priority(priority_temp)
    up
  end

  def change_priority(priority)
    self.priority = priority
    save!(validate: false)
  end

  private

  
end
