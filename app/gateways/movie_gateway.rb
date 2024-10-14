class MovieGateway
  def self.connection
    Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.params["api_key"] = Rails.application.credentials.tmdb_movie[:key]
    end
  end

  def self.top_rated
    response = connection.get("/3/movie/top_rated")
    parse_response(response)[:results].map { |movie| format_movie(movie) }
  end

  def self.search(query)
    response = connection.get("/3/search/movie?query=#{query}")
    parse_response(response)[:results].map { |movie| format_movie(movie) }
  end

  def self.movie_details(id)
    movie = parse_response(connection.get("/3/movie/#{id}"))
    # movie[:cast] = parse_response(connection.get("/3/movie/#{id}/credits"))[:cast].first(10)
    movie[:cast] = parse_response(connection.get("/3/movie/#{id}/credits"))[:cast]
    movie[:reviews] = parse_response(connection.get("/3/movie/#{id}/reviews"))[:results]
    movie
  end

  def self.parse_response(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.format_movie(movie)
    {
      "id": movie[:id],
      "type": "movie",
      "attributes": {
        "title": movie[:title],
        "vote_average": movie[:vote_average]
      }
    }
  end
end