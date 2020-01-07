class Todo < ApplicationRecord
  before_create :set_priority_active_status
  belongs_to :user
  validates :user_id, presence: true
  validates :body, presence: true,
                    length: { minimum: 8 }
  private
  def set_priority_active_status
    self.priority= Todo.order(updated_at: :desc).first.nil? ? 1 : (Todo.order(updated_at: :desc).first.priority)+1
  end
end
