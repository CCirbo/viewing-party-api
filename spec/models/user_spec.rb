require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:password) }
    it { should have_secure_password }
    it { should have_secure_token(:api_key) }
  end

  describe "valid_api_key?" do
    it "returns true when the api_key matches" do
      user = User.create!(name: "Host Name", username: "host_username", password: "abc123", api_key: "valid_api_key")
      
      expect(user.valid_api_key?("valid_api_key")).to eq(true)
    end

    it "returns false when the api_key doesn't match" do
      user = User.create!(name: "Host Name", username: "host_username", password: "abc123", api_key: "valid_api_key")
      
      expect(user.valid_api_key?("invalid_api_key")).to eq(false)
    end
  end
end