require 'spec_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        [ Place.new(:name => "Oljenkorsi") ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end
  
  it "if many are returned by the API, all are shown at the page" do
    places = []    
    places << Place.new(name: "Pullman Bar")
    places << Place.new(name: "Suomenlinnan Panimo")
  
    BeermappingApi.stub(:places_in).with("Helsinki").and_return(places)

    visit places_path
    fill_in('city', with: 'Helsinki')
    click_button 'Search'

    expect(page).to have_content "Pullman Bar"
    expect(page).to have_content "Suomenlinnan Panimo"
  end
  
  it "if none is returned by the API, none is shown at the page" do
    places = []

    BeermappingApi.stub(:places_in).with("Helsinki").and_return(places)

    visit places_path
    fill_in('city', with: 'Helsinki')
    click_button 'Search'

    expect(page).to have_content "No locations in Helsinki"
    expect(page).not_to have_content "Pullman Bar"
  end
  
end