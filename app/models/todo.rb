# frozen_string_literal: true

class Todo < ApplicationRecord
  before_create :set_priority_active_status
  belongs_to :user
  validates :user_id, presence: true
  validates :body, presence: true,
                   length: { minimum: 8 }
  self.per_page = 5

  scope :sort_by_priority, ->(active) { where(active: active).order(priority: :desc) }
  scope :search, ->(search) { where('body like ?', "%#{search}%") }

  def priority_switch(symbol, todos)
    up = symbol == '>' ? todos.where("priority#{symbol} ?", priority).last
     : todos.where("priority#{symbol} ?", priority).first
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

  def set_priority_active_status
    high_priority_todo = Todo.order(priority: :desc).first
    self.priority = high_priority_todo.nil? ? 1 : high_priority_todo.priority + 1
  end
end
