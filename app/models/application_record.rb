class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  WillPaginate.per_page = 5
end
