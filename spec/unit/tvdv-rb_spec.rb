require 'spec_helper'

describe TVDB::Client do

  before do
    @client = TVDB::Client.new("foo")
  end

  it "should return results for get_series_by_name" do
    stub_request(:get, "http://www.thetvdb.com/api/GetSeries.php?seriesname=Breaking%20Bad").to_return(:body => load_response("get_series.xml"), :status => 200)
    stub_request(:get, "http://www.thetvdb.com/api/foo/series/81189").to_return(:body => load_response("get_series_detail.xml"), :status => 200)
    results = @client.get_series_by_name "Breaking Bad", detailed_response=true
    results.length.should eq 1
    breaking_bad = results.first
    breaking_bad.series_name.should eq "Breaking Bad"
    breaking_bad.genres.should eq ["Drama"]
    breaking_bad.actors.should eq ["Bryan Cranston", "Aaron Paul", "Dean Norris", "RJ Mitte", "Betsy Brandt", "Anna Gunn", "Christopher Cousins", "Steven Michael Quezada", "Jonathan Banks", "Giancarlo Esposito", "Bob Odenkirk"]
  end

  it "should return episodes for a series" do
    stub_request(:get, "http://www.thetvdb.com/api/GetSeries.php?seriesname=Breaking%20Bad").to_return(:body => load_response("get_series.xml"), :status => 200)
    stub_request(:get, "http://www.thetvdb.com/api/foo/series/81189/all").to_return(:body => load_response("episodes.xml"), :status => 200)
    breaking_bad = @client.get_series_by_name("Breaking Bad", detailed_response=false).first
    breaking_bad.episodes.all.should be_a Array
    breaking_bad.episodes.all.length.should eq 60
  end

  it "should return epsiodes when searched for by overview" do
    stub_request(:get, "http://www.thetvdb.com/api/GetSeries.php?seriesname=Breaking%20Bad").to_return(:body => load_response("get_series.xml"), :status => 200)
    stub_request(:get, "http://www.thetvdb.com/api/foo/series/81189/all").to_return(:body => load_response("episodes.xml"), :status => 200)
    stub_request(:get, "http://www.thetvdb.com/api/foo/series/81189").to_return(:body => load_response("episodes.xml"), :status => 200)
    breaking_bad = @client.get_series_by_name("Breaking Bad", detailed_response=true).first
    episodes = breaking_bad.episodes.search_by_overview "chemistry"
    episodes.all.length.should eq 1
  end

end