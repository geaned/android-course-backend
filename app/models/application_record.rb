require 'error_messages'

class ApplicationRecord < ActiveRecord::Base
  extend ErrorMessage
  self.abstract_class = true
end
