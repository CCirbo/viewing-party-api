require "rails_helper"

RSpec.describe MovieDetail do
  it "should instantiate with correct attribute values" do
    movie_data = {
      id: 122,
      title: "The Lord of the Rings: The Return of the King",
      release_date: "2003-12-01",
      vote_average: 8.9,
      runtime: 201,
      genres: [{ name: "Fantasy" }, { name: "Adventure" }],
      overview: "Gandalf and Aragorn lead the World of Men against Sauron's army to draw his gaze from Frodo and Sam.",
      cast: [{ name: "Elijah Wood", character: "Frodo" }],
      reviews: [{ author: "John Doe", content: "Amazing movie!" }]
    }

    movie_detail = MovieDetail.new(movie_data)

    expect(movie_detail.id).to eq("122")
    expect(movie_detail.title).to eq("The Lord of the Rings: The Return of the King")
    expect(movie_detail.release_year).to eq(2003)
    expect(movie_detail.vote_average).to eq(8.9)
    expect(movie_detail.runtime).to eq(201)
    expect(movie_detail.genres).to eq(["Fantasy", "Adventure"])
    expect(movie_detail.summary).to eq("Gandalf and Aragorn lead the World of Men against Sauron's army to draw his gaze from Frodo and Sam.")
    expect(movie_detail.cast.first[:name]).to eq("Elijah Wood")
    expect(movie_detail.reviews.first[:author]).to eq("John Doe")
  end
end