require 'spec_helper'

describe "BeermappingApi" do
  it "When HTTP GET returns one entry, it is parsed and returned" do

    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*tampere/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("tampere")

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("O'Connell's Irish Bar")
    expect(place.street).to eq("Rautatienkatu 24")
  end
  
  it "When HTTP GET returns none entry, it retuns an empty table" do

    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*kuusamo/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("kuusamo")

    expect(places.size).to eq(0)
  end

  it "When HTTP GET returns many entries, it retuns many bars" do

    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>11960</id><name>Ma Che Siete Venuti A Fa'</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=11960</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=11960&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=11960&amp;d=1&amp;type=norm</blogmap><street>Via di Benedetta 25 - Trastevere</street><city>Rome</city><state></state><zip>00153</zip><country>Italy</country><phone>3805074938</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>15648</id><name>Open Baladin</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=15648</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=15648&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=15648&amp;d=1&amp;type=norm</blogmap><street>Via degli Specchi, 6</street><city>Rome</city><state></state><zip>00186</zip><country>Italy</country><phone>06 683 8989</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>17304</id><name>Birreria Pub McQueen</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=17304</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=17304&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=17304&amp;d=1&amp;type=norm</blogmap><street>via Aurelia 77</street><city>Rome</city><state></state><zip>00165</zip><country>Italy</country><phone>39 06 631872</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
		END_OF_STRING

    stub_request(:get, /.*rome/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("rome")

    expect(places.size).to eq(3)
    place = places.first
    expect(place.name).to eq("Ma Che Siete Venuti A Fa'")
    expect(place.street).to eq("Via di Benedetta 25 - Trastevere")
  end
  
  describe "in case of cache miss" do

    before :each do
      Rails.cache.clear
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do
      canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*tampere/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

      places = BeermappingApi.places_in("tampere")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("O'Connell's Irish Bar")
      expect(place.street).to eq("Rautatienkatu 24")
    end
  end

  describe "in case of cache hit" do

    it "When one entry in cache, it is returned" do
      canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*tampere/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

      # ensure that data found in cache
      BeermappingApi.places_in("tampere")

      places = BeermappingApi.places_in("tampere")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("O'Connell's Irish Bar")
      expect(place.street).to eq("Rautatienkatu 24")
    end
  end 

end