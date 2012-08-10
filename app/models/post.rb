class Post < ActiveRecord::Base

  validates :article_id, :presence => true, :uniqueness => true
  validates :headline, :presence => true
  validates :publish_date, :presence => true
  validates :content, :presence => true

  def publish_date=(datetime)
    if datetime.kind_of?(String)
      datetime_parts = datetime.scan(/(\d{1,2})\/(\d{1,2})\/(\d{2,4}) (\d{1,2}):(\d{1,2})/mi)[0]
      year = datetime_parts[2].length == 2 ? 2000 + datetime_parts[2].to_i : datetime_parts[2].to_i
      month = datetime_parts[0].to_i
      day = datetime_parts[1].to_i
      hour = datetime_parts[3].to_i
      minute = datetime_parts[4].to_i
      write_attribute(:publish_date, DateTime.new(year, month, day, hour, minute))
    else
      write_attribute(:publish_date, datetime)
    end
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
