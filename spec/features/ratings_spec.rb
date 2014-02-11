require 'spec_helper'
include OwnTestHelper


describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:brewery2) { FactoryGirl.create :brewery, name:"Panimo2" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery, style:"Pale Ale" }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:beer3) { FactoryGirl.create :beer, name:"Olut", brewery:brewery2, style:"Lager" }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user, username:"Matt" }


  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
  
  it "all ratings are shown on the ratings page" do
    create_beers_with_ratings(1,2,3, user)
    visit ratings_path
    expect(page).to have_content 'Number of ratings: 3'
    expect(page).to have_content 'anonymous 1'
    expect(page).to have_content 'anonymous 2'
    expect(page).to have_content 'anonymous 3'
  end
  
  it "user's all ratings are shown on the user's page" do
    create_beers_with_ratings(1,2,3, user)
    create_beers_with_ratings(5,10,15, user2)
    visit user_path(user)
    expect(page).to have_content 'has done 3 ratings, average 2'
    expect(page).to have_content 'anonymous 1'
    expect(page).not_to have_content 'anonymous 15'
    expect(page).to have_content 'anonymous 2'
    expect(page).to have_content 'anonymous 3'
    #save_and_open_page
  end
  
  it "user can delete his rating and it will be deleted from db" do
    create_beers_with_ratings(1,2,3, user)
    create_beers_with_ratings(5, user2)
    visit user_path(user)
    page.all(:link,"delete")[1].click
    visit ratings_path
    expect(page).to have_content 'Number of ratings: 3'
    expect(page).not_to have_content '2'
  end
  
  it "user's favourite beer style nad brewery is on the user's page" do
    rating = Rating.create  beer:beer1, score:10, user:user
    rating = Rating.create  beer:beer1, score:20, user:user
    rating = Rating.create  beer:beer3, score:3, user:user
    visit user_path(user)
    expect(page).to have_content 'style of beer: Pale Ale'
    expect(page).to have_content 'Favorite brevery: Koff'
  end
  
  
  
end