class Api::V1::MoviesController < ApplicationController
    def index
      conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
        faraday.params['api_key'] =  Rails.application.credentials.tmdb_movie[:key]
      end
      if params[:search]
        response = conn.get("/3/search/movie?query=#{params[:search]}")
      # elsif params[:details] 
      #   movie = jsonify_response(conn.get("/3/movie/#{params[:movie_id]}"))
      #   movie[:cast] = jsonify_response(conn.get("/3/movie/#{params[:movie_id]/credits}"))[:cast] 
      #   movie[:reviews] = jsonify_response(conn.get("/3/movie/#{params[:movie_id]/reviews}"))[:results] 
      
      else
        response = conn.get("/3/movie/top_rated")
      end
    
    # api_key = Rails.application.credentials.tmbd[:key]
    # conn = Faraday.new(url: "https://api.themoviedb.org") 
    # response = conn.get("3/movie/top_rated"), { api_key: api_key})
    json = JSON.parse(response.body, symbolize_names: true)[:results]
    formatted_json = json.map do |movie|
        {
           "id": movie[:id], 
           "type": "movie",
           "attributes": {
            "title": movie[:title],
            "vote_average": movie[:vote_average]
           }
        }
    end

    render json: { data: formatted_json }
  end

  # private

  # def jsonify_response(response)
  # JSON.parse(response.body, symbolize_names: true)[:results]
  # end


end

# get https://api.themoviedb.org/3/search/movie