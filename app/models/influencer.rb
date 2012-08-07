class Influencer < ActiveRecord::Base

  validates :name, :presence => true, :uniqueness => true
  validates :influencerType, :presence => true
  belongs_to :influencerType

end
