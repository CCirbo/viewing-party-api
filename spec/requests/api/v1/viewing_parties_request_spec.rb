require "rails_helper"

RSpec.describe "Viewing Parties Endpoint", type: :request do
  describe "happy path" do
    it "creates a viewing party" do
      host = User.create!(name: "Host Name", username: "host_username", password: "abc123", api_key: "valid_api_key")
      invitee1 = User.create!(id: 11, name: "Barbara", username: "leo_fan", password: "test123")
      invitee2 = User.create!(id: 7, name: "Ceci", username: "titanic_forever", password: "abcqwerty")
      invitee3 = User.create!(id: 5, name: "Peyton", username: "star_wars_geek_8", password: "blueivy")
      
      post "/api/v1/viewing_parties", params: {
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        api_key: host.api_key,
        invitees: [invitee1.id, invitee2.id, invitee3.id]
      }

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:name]).to eq("Juliet's Bday Movie Bash!")
      expect(json[:attributes][:invitees].count).to eq(3)
      expected_invitees = ["Barbara", "Ceci", "Peyton"]
      actual_invitees = json[:attributes][:invitees].map { |invitee| invitee[:name] }
      expect(actual_invitees).to match_array(expected_invitees)
      expect(response).to have_http_status(201)
    end
  end
 
  describe "sad path" do
    it "returns status code 401 when the API key is invalid" do
      host = User.create!(name: "Host Name", username: "host_username", password: "abc123", api_key: "valid_api_key")
      invitee1 = User.create!(id: 11, name: "Barbara", username: "leo_fan", password: "test123")
      invitee2 = User.create!(id: 7, name: "Ceci", username: "titanic_forever", password: "abcqwerty")
      invitee3 = User.create!(id: 5, name: "Peyton", username: "star_wars_geek_8", password: "blueivy")
      
      invalid_attributes = {
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        api_key: !host.api_key,
        invitees: [invitee1.id, invitee2.id, invitee3.id]
      }

      post "/api/v1/viewing_parties", params: invalid_attributes

      expect(response).to have_http_status(401)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("Invalid API key")
    end
  
    it "returns status code 422 when required fields are missing" do
      host = User.create!(name: "Host Name", username: "host_username", password: "abc123", api_key: "valid_api_key")
      invitee1 = User.create!(id: 11, name: "Barbara", username: "leo_fan", password: "test123")
      invitee2 = User.create!(id: 7, name: "Ceci", username: "titanic_forever", password: "abcqwerty")
      invitee3 = User.create!(id: 5, name: "Peyton", username: "star_wars_geek_8", password: "blueivy")
      
      invalid_attributes = {
        # no name triggers error
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption",
        api_key: host.api_key,
        invitees: [invitee1.id, invitee2.id, invitee3.id]
      }

      post "/api/v1/viewing_parties", params: invalid_attributes

      expect(response).to have_http_status(422)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to include("Name can't be blank")
    end
  end
end


