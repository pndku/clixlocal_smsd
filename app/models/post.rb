class Post < ActiveRecord::Base

  validates :article_id, :presence => true, :uniqueness => true
  validates :headline, :presence => true
  validates :publish_date, :presence => true
  validates :content, :presence => true
  belongs_to :postPriority

  class << self
    def fresh
      order("publish_date DESC")
    end

    def prioritized(priority)
      postPriority = PostPriority.find_by_name(priority)
      where(:postPriority_id => postPriority.id)
    end
  end

end
