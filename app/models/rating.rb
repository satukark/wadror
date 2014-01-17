class Rating < ActiveRecord::Base

  belongs_to :beer
  
  def to_s
    b = Beer.find_by id:beer_id
    return b.name + " "  + "#{score}"
  end
end
