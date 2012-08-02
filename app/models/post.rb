class Post < ActiveRecord::Base

  validates :headline, :presence => true

end
