class Post < ActiveRecord::Base

  validates :article_id, :presence => true, :uniqueness => true
  validates :headline, :presence => true

end
