# frozen_string_literal: true

class Todo < ApplicationRecord
  before_create :set_priority_active_status
  belongs_to :user
  validates :user_id, presence: true
  validates :body, presence: true,
                   length: { minimum: 8 }
  self.per_page = 5
  
  def change_priority(priority)
    self.priority = priority
    save!(validate: false)
  end

  private

  def set_priority_active_status
    high_priority_todo = Todo.order(priority: :desc).first
    self.priority = high_priority_todo.nil? ? 1 : high_priority_todo.priority + 1
  end
end
