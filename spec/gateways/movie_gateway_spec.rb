require "rails_helper"

RSpec.describe MovieGateway do
  it "should return top-rated movies in the correct format", :vcr do
    top_rated_movies = MovieGateway.top_rated
    expect(top_rated_movies).to be_an(Array)
    expect(top_rated_movies.first[:id]).to be_an(Integer)
    expect(top_rated_movies.first[:attributes][:title]).to be_a(String)
    expect(top_rated_movies.first[:attributes][:vote_average]).to be_a(Float)
    expect(top_rated_movies.first[:id]).to eq(278)
    expect(top_rated_movies.first[:attributes][:title]).to eq("The Shawshank Redemption")
    expect(top_rated_movies.first[:attributes][:vote_average]).to eq(8.707)
  end

  it "should return movies that match the search query", :vcr do
    search_results = MovieGateway.search("Lord of the Rings")
    expect(search_results).to be_an(Array)
    expect(search_results.first[:id]).to be_an(Integer)
    expect(search_results.first[:attributes][:title]).to include("Lord of the Rings")
    expect(search_results.first[:attributes][:vote_average]).to be_a(Float)
  end

  it "should return movie details with cast and reviews in the correct format", :vcr do
    movie_details = MovieGateway.movie_details(278)
    expect(movie_details[:id]).to eq(278)
    expect(movie_details[:title]).to eq("The Shawshank Redemption")
    expect(movie_details[:vote_average]).to be_a(Float)
    expect(movie_details[:cast]).to be_an(Array)
    expect(movie_details[:cast].first[:name]).to be_a(String)
    expect(movie_details[:reviews]).to be_an(Array)
    expect(movie_details[:reviews].first[:author]).to be_a(String)
  end
end