class MovieSerializer
  def initialize(movie_detail)
    @movie = movie_detail
  end

  def serialize
    {
      data: {
        id: @movie.id,
        type: "movie",
        attributes: {
          title: @movie.title,
          release_year: @movie.release_year,
          vote_average: @movie.vote_average,
          runtime: @movie.runtime_conversion,
          genres: @movie.genres,
          summary: @movie.summary,
          cast: @movie.formatted_cast,
          total_reviews: @movie.total_reviews,
          reviews: @movie.formatted_reviews
        }
      }
    }
  end
end