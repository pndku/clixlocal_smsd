class Post < ActiveRecord::Base

  validates :article_id, :presence => true, :uniqueness => true
  validates :headline, :presence => true
  validates :publish_date, :presence => true
  validates :content, :presence => true

  def important=(value)
    if [true, "true", 1, "1"].include?(value)
      value = true
    else
      value = false
    end
    write_attribute(:important, value)
  end

  class << self
    def fresh
      order("publish_date DESC")
    end

    def important()
      where(:important => true)
    end
  end

end
