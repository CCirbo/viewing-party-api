require "rails_helper"

RSpec.describe "Movie Endpoint API", type: :request do 
  describe "happy path" do
    it "can retrieve a list of 20 top rated movies", :vcr do
      get "/api/v1/movies"  

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)[:data]
  
      expect(json.count).to eq(20) 
  
      movie = json.first
      expect(movie[:type]).to eq("movie")
      expect(movie[:id]).to be_a(Integer)
      expect(movie[:attributes]).to have_key(:title)
      expect(movie[:attributes]).to have_key(:vote_average)
    end

    it "can retrieve movies in a search", :vcr do
      get "/api/v1/movies", params: { search: "Lord of the Rings"}  

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json.count).to eq(20) 

      movie = json.first
      expect(movie[:type]).to eq("movie")
      expect(movie[:id]).to be_a(Integer)
      expect(movie[:attributes]).to have_key(:title)
      expect(movie[:attributes]).to have_key(:vote_average)
    end

    it "can retrieve movies details including cast and reviews", :vcr do
      movie_id = 122
      get "/api/v1/movies/#{movie_id}"
      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes]).to have_key(:title)
      expect(json[:attributes]).to have_key(:release_year)
      expect(json[:attributes]).to have_key(:vote_average)
      expect(json[:attributes]).to have_key(:runtime)
      expect(json[:attributes]).to have_key(:genres)
      expect(json[:attributes]).to have_key(:summary)
      expect(json[:attributes]).to have_key(:cast)
      expect(json[:attributes]).to have_key(:reviews)
      expect(json[:attributes][:cast]).to be_an(Array)
      expect(json[:attributes][:cast].size).to be <= 10
      expect(json[:attributes][:cast].first).to have_key(:actor)
      expect(json[:attributes][:cast].first).to have_key(:character)

      expect(json[:attributes][:reviews]).to be_an(Array)
      expect(json[:attributes][:reviews].size).to be <= 5
      expect(json[:attributes][:reviews].first).to have_key(:author)
    end
  end
end
