# frozen_string_literal: true

class Todo < ApplicationRecord
  # belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :users, through: :shares
  has_many :shares, dependent: :destroy
  # validates :user_id, presence: true
  scope :sort_by_priority, -> { order(priority: :desc) }
  validates :body, presence: true,
                   length: { minimum: 8 }

  self.per_page = 5
  scope :select_by_active, ->(active) { where(active: active) }
  scope :search, ->(search) { where('body like ?', "%#{search}%") }

  def create_progress(progress,user_id)
    if progress < 100
      comment_body = "Task has been updated from <span class='green-data'>
      #{self.status}%</span> to <span class='green-data'>#{progress}%</span>"
    else
      comment_body = "Status of the task changed to
      <span class='green-data'>Done</span>"
    end
    @comment = self.comments.build(description: comment_body,
       user_id: user_id)
    self.update(status: progress)
    @comment.save!
  end

  def create_share(users)
    return if users.nil?
    
    p users.nil?
    users.each do |i|
      share = self.shares.build(user_id: i.to_i)
      share.save!
    end
  end
end
