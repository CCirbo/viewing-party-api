class Api::V1::MoviesController < ApplicationController
  def index
    movies = if params[:search]
               MovieService.search(params[:search])
             else
               MovieService.top_rated
             end

    render json: { data: movies }
  end

  def show
    movie = MovieService.movie_details(params[:id])
    movie_detail = MovieDetail.new(movie)
# require 'pry'; binding.pry
    # data = []

    render json: MovieSerializer.new(movie_detail).serialize
  end
end


# def show
#   conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
#     faraday.params['api_key'] = Rails.application.credentials.tmdb_movie[:key]
#   end

#   movie = jsonify_response(conn.get("/3/movie/#{params[:id]}"))
#   movie[:cast] = jsonify_response(conn.get("/3/movie/#{params[:id]}/credits"))[:cast].first(10)
#   movie[:reviews] = jsonify_response(conn.get("/3/movie/#{params[:id]}/reviews"))[:results].first(5)
#   # require 'pry'; binding.pry
#   movie_detail = MovieDetail.new(movie)

#   render json: movie, serializer: MovieSerializer
# end

# private

# def jsonify_response(response)
# JSON.parse(response.body, symbolize_names: true)
# end


# end
      # conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      #   faraday.params['api_key'] =  Rails.application.credentials.tmdb_movie[:key]
      # end
      # if params[:search]
      #   response = conn.get("/3/search/movie?query=#{params[:search]}")
      # elsif params[:details] 
      #   movie = jsonify_response(conn.get("/3/movie/#{params[:movie_id]}"))
      #   movie[:cast] = jsonify_response(conn.get("/3/movie/#{params[:movie_id]/credits}"))[:cast] 
      #   movie[:reviews] = jsonify_response(conn.get("/3/movie/#{params[:movie_id]/reviews}"))[:results] 
      
      # else
      #   response = conn.get("/3/movie/top_rated")
      # end
    
    # api_key = Rails.application.credentials.tmbd[:key]
    # conn = Faraday.new(url: "https://api.themoviedb.org") 
    # response = conn.get("3/movie/top_rated"), { api_key: api_key})
  #   json = JSON.parse(response.body, symbolize_names: true)[:results]
  #   formatted_json = json.map do |movie|
  #       {
  #          "id": movie[:id], 
  #          "type": "movie",
  #          "attributes": {
  #           "title": movie[:title],
  #           "vote_average": movie[:vote_average]
  #          }
  #       }
  #   end

  #   render json: { data: formatted_json }
  # end


# get https://api.themoviedb.org/3/search/movie