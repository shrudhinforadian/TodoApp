class ApplicationRecord < ActiveRecord::Base
  attr_accessor :current_user
  self.abstract_class = true
  WillPaginate.per_page = 5
end
