class Brewery < ActiveRecord::Base
	include RatingAverage

	has_many :beers, :dependent => :destroy
	has_many :ratings, :through => :beers
	
    validates_presence_of :name
    validates_numericality_of :year, { greater_than_or_equal_to: 1042,
                                      only_integer: true }
                                      
  validate :date_cannot_be_in_the_future
  
  
  
  def date_cannot_be_in_the_future
    if year > Date.today.year
      errors.add(:year, "can't be in the future")
    end
  end
  
  
  
end


