require "rails_helper"

RSpec.configure do |config| 
    config.formatter = :documentation 
end

RSpec.describe "Movie Endpoint API", type: :request do 
  describe "happy path" do
    it "can retrieve a list of 20 top rated movies", :vcr do
      # VCR.use_cassette("can_retrieve_a_list_of_20_top_rated_movies") do
          # json_response = File.read('spec/fixtures/movies_query.json')

          # stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#(Rails.application.credentials.tmdb_key[:key]}")
          #   .to_return(status: 200, body: json_response)
  
          # stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated")
          #     .with(query: { api_key: Rails.application.credentials.tmdb[:key] })
          #     .to_return(status: 200, body: stubbed_response, headers: {})

        get "/api/v1/movies"  

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)[:data]
    
        expect(json.count).to eq(20) 
    
        movie = json.first
        expect(movie[:type]).to eq("movie")
        expect(movie[:id]).to be_a(Integer)
        expect(movie[:attributes]).to have_key(:title)
        expect(movie[:attributes]).to have_key(:vote_average)
      # end
    end

    it "can retrieve movies in a search", :vcr do
      # VCR.use_cassette("can_retrieve_movies_in_a_search") do

        get "/api/v1/movies", params: { search: "Lord of the Rings"}  

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)[:data]
        # require 'pry'; binding.pry
        expect(json.count).to eq(20) 

        movie = json.first
        expect(movie[:type]).to eq("movie")
        expect(movie[:id]).to be_a(Integer)
        expect(movie[:attributes]).to have_key(:title)
        expect(movie[:attributes]).to have_key(:vote_average)
      # end
    end

    it "can retrieve movies details including cast and reviews", :vcr do
      # VCR.use_cassette("movie show details") do
        movie_id = 122
        # require 'pry'; binding.pry

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
        
        # require 'pry'; binding.pry
        expect(json[:attributes][:cast]).to be_an(Array)
        expect(json[:attributes][:cast].size).to be <= 10
        expect(json[:attributes][:cast].first).to have_key(:actor)
        expect(json[:attributes][:cast].first).to have_key(:character)

        expect(json[:attributes][:reviews]).to be_an(Array)
        expect(json[:attributes][:reviews].size).to be <= 5
        expect(json[:attributes][:reviews].first).to have_key(:author)
        # expect(json[:attributes][:reviews].first).to have_key(:reviews)
      # end
    end
  end
end
