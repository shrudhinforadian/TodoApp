# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :todo
  validates :user_id, presence: true
  validates :todo_id, presence: true
  validates :description, presence: true
end
