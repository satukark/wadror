class User < ActiveRecord::Base
  include RatingAverage

  validates :username, uniqueness: true,
                       length: { in: 3..15 }

  validates :password, length: { minimum: 3 },
                       format: { with: /.*(\d.*[A-Z]|[A-Z].*\d).*/,
                                 message: "should contain a uppercase letter and a number" }


  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
  
  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end
  
  def favorite_brewery
    return nil if ratings.empty?
   group_by_brewery = ratings.group_by { |s| s.beer.brewery }
   (average_ratings group_by_brewery).max_by { |brewery, average| average }[0]
  end
  
  def favorite_style
    return nil if ratings.empty?
    group_by_style = ratings.group_by { |s| s.beer.style }
    (average_ratings group_by_style).max_by { |style, average| average }[0]
  end
  
  def average_ratings(groups)
    groups.keys.each do |key|
      sum = groups[key].inject(0.0) { |sum, rating| sum + rating.score }
      groups[key] = sum / groups[key].count
    end
    return groups
  end
end

