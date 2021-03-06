# frozen_string_literal: true

class Share < ApplicationRecord
  attr_accessor :current_user
  before_create :set_priority_active_status, :set_ownership
  belongs_to :user
  belongs_to :todo
  validates :user_id, presence: true
  # before_destroy :check_is_owner
  # validates :todo_id, presence: true
  scope :sort_by_priority, -> { order(priority: :desc) }
  scope :select_by_owner, ->(id) { where(todo_id: id, is_owner: 1) }

  def priority_switch(direction, shares)
    switch = direction == 'up' ? shares.where('priority > ?', priority).last
     : shares.where('priority < ?', priority).first
    priority_temp = priority
    change_priority(switch.priority)
    switch.change_priority(priority_temp)
    switch
  end

  def destroy_share(todo)
      todo.destroy if self.is_owner
      self.destroy
  end

  def change_priority(priority)
    self.priority = priority
    save!(validate: false)
  end

  private

  def set_priority_active_status
    high_priority_todo = Share.order(priority: :desc).first
    self.priority = high_priority_todo.nil? ? 1 : high_priority_todo.priority + 1
  end

  def set_ownership
    self.is_owner = Share.select_by_owner(todo_id).first.nil? ? true : false
  end
end
