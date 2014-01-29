class Membership < ActiveRecord::Base

  belongs_to :beer_club
  belongs_to :user
  
  validates_uniqueness_of :beer_club_id, :scope => [:user_id]

end
