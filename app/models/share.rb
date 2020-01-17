class Share < ApplicationRecord.
  before_create :set_priority_active_status
  belongs_to :user
  belongs_to :todo
  validates :user_id, presence: true
  validates :todo_id, presence: true

  private

  def set_priority_active_status
    high_priority_todo = Share.order(priority: :desc).first
    self.priority = high_priority_todo.nil? ? 1 : high_priority_todo.priority + 1
  end
end
