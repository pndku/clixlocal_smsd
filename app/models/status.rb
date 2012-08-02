class Status < ActiveRecord::Base

  validates :content, :presence => true

end
