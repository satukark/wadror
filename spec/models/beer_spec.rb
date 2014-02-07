require 'spec_helper'

describe Beer do
  it "has the beername set correctly" do
    beer = Beer.new name:"Koff"
    beer.name.should == "Koff"
  end

  it "is saved with name and style" do
    beer = Beer.create name:"Koff", style:"Lager"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end
  
    it "is not saved without name" do
    beer = Beer.create style:"Lager"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
  
    it "isn't saved without style" do
    beer = Beer.create name:"Koff"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  
end