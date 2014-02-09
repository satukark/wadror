require 'spec_helper'

describe "Beers page" do

	let!(:brewery) { FactoryGirl.create :brewery, name:"anonymous" }

   
  it "should not have any before been created" do
    visit beers_path
    expect(page).to have_content 'Listing beers'
    expect(page).to have_content 'Number of beers: 0'
  end
  
  it "should have valid beer name" do
    FactoryGirl.create :user
    sign_in(username:"Pekka", password:"Foobar1")
    user = User.create username:"Pekka"
    visit new_beer_path
    fill_in('beer_name', with:"")
    select('Lager', from:'beer[style]')
    select('anonymous', from:'beer[brewery_id]')

    click_button "Create Beer"
    expect(page).to have_content "Name can't be blank"
    expect(brewery.beers.count).to eq(0)
  end
  
  it "lists the existing breweries and their total number" do
    beers = ["Olut1", "Olut2", "Olut3"]
    beers.each do |beer_name|
      FactoryGirl.create(:beer, name:beer_name)
    end

    visit beers_path

    expect(page).to have_content "Number of beers: #{beers.count}"

    beers.each do |beer_name|
    expect(page).to have_content beer_name
    end
  end
  
    it "allows user to navigate to page of a Beer" do
    beers = ["Olut1", "Olut2", "Olut3"]
    style = "Lager"
    beers.each do |beer_name|
    FactoryGirl.create(:beer, name: beer_name)
    end

    visit beers_path

    click_link "Olut1"

    expect(page).to have_content "Olut1"
    expect(page).to have_content "Lager"
  end
end