class MovieDetail
  attr_reader :id, 
              :title, 
              :release_year, 
              :vote_average, 
              :runtime, 
              :genres, 
              :summary, 
              :cast, 
              :total_reviews, 
              :reviews

  def initialize(details)
    # require 'pry'; binding.pry
    @id = details[:id].to_s
    @title = details[:title]
    @release_year = details[:release_date]&.split('-').first.to_i
    @vote_average = details[:vote_average]
    @runtime = details[:runtime]
    @genres = details[:genres].map { |genre| genre[:name] }
    @summary = details[:overview]
    @cast = details[:cast].take(10)
    @total_reviews = details[:reviews].count
    @reviews = details[:reviews].take(5)
      
  end

  def runtime_conversion
    hours = @runtime / 60
    minutes = @runtime % 60
    "#{hours} hours, #{minutes} minutes"
  end

  def formatted_cast
    @cast.map do |cast_member|
      # require 'pry'; binding.pry
      {
        character: cast_member[:character],
        actor: cast_member[:name]
      }
    end
  end
  
  def formatted_reviews
    @reviews.map do |review|
      {
        author: review[:author],
        review: review[:content]
      }
    end
  end

end