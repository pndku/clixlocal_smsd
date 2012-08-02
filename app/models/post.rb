class Post < ActiveRecord::Base

  validates :article_id, :presence => true
  validates :headline, :presence => true

end
