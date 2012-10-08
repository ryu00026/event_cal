class Calendar < ActiveRecord::Base
  acts_as_paranoid
  # attr_accessible :title, :body
end
