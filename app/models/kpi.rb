class Kpi < ActiveRecord::Base

  validates :date, :presence => true, :uniqueness => true

end
