class Api::V1::MoviesController < ApplicationController
  def index
    movies = if params[:search]
               MovieGateway.search(params[:search])
             else
               MovieGateway.top_rated
             end

    render json: { data: movies }
  end

  def show
    movie = MovieGateway.movie_details(params[:id])
    movie_detail = MovieDetail.new(movie)
    render json: MovieSerializer.new(movie_detail).serialize
  end
end

