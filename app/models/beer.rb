class Beer < ActiveRecord::Base
  belongs_to :brewery
    has_many :ratings
    
    def average_count
    ratings.average("score")
	end  
end
