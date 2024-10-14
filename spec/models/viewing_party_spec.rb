require "rails_helper"

RSpec.describe ViewingParty, type: :model do
  describe "relationships" do
    it { should have_many(:user_parties) }
    it { should have_many(:users).through(:user_parties) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:movie_id) }
    it { should validate_presence_of(:movie_title) }
  end
end

describe "Viewing Parties" do
  it "creates a viewing party with host and invitees" do
    host = User.create!(name: "Host Name", username: "host_username", password: "abc123", api_key: "valid_api_key")
    invitee1 = User.create!(id: 11, name: "Barbara", username: "leo_fan", password: "test123")
    invitee2 = User.create!(id: 7, name: "Ceci", username: "titanic_forever", password: "abcqwerty")

    viewing_party_params = { name: "My Party", start_time: "2024-10-13 14:00:00", end_time: "2024-10-13 16:00:00", movie_id: 1, movie_title: "Cool Movie" }
    invitees = [invitee1.id, invitee2.id]

    viewing_party = ViewingParty.create_with_invitees(host, viewing_party_params, invitees)

    expect(viewing_party.persisted?).to eq(true)
    expect(viewing_party.users).to include(host, invitee1, invitee2)

    host_party = UserParty.find_by(viewing_party_id: viewing_party.id, user_id: host.id)
    expect(host_party.host).to eq(true)

    invitee1_party = UserParty.find_by(viewing_party_id: viewing_party.id, user_id: invitee1.id)
    invitee2_party = UserParty.find_by(viewing_party_id: viewing_party.id, user_id: invitee2.id)

    expect(invitee1_party).to_not be_nil
    expect(invitee2_party).to_not be_nil
  end

  it "does not add invitees if the viewing party is invalid" do
    host = User.create!(name: "Host Name", username: "host_username", password: "abc123", api_key: "valid_api_key")
    invitee1 = User.create!(id: 11, name: "Barbara", username: "leo_fan", password: "test123")

    invalid_params = { name: nil, start_time: nil, end_time: nil, movie_id: nil, movie_title: nil }

    viewing_party = ViewingParty.create_with_invitees(host, invalid_params, [invitee1.id])

    expect(viewing_party.persisted?).to eq(false)
    expect(viewing_party.users).to_not include(invitee1)

    user_party = UserParty.find_by(viewing_party_id: viewing_party.id, user_id: invitee1.id)
    expect(user_party).to be_nil
  end

  it "creates a viewing party without invitees" do
    host = User.create!(name: "Host Name", username: "host_username", password: "abc123", api_key: "valid_api_key")

    viewing_party_params = { name: "My Solo Party", start_time: "2024-10-13 14:00:00", end_time: "2024-10-13 16:00:00", movie_id: 1, movie_title: "Cool Movie" }
    invitees = [] 

    viewing_party = ViewingParty.create_with_invitees(host, viewing_party_params, invitees)

    expect(viewing_party.persisted?).to eq(true)
    expect(viewing_party.users).to include(host)
    expect(viewing_party.users.count).to eq(1) 

    host_party = UserParty.find_by(viewing_party_id: viewing_party.id, user_id: host.id)
    expect(host_party.host).to eq(true)
  end

  it "does not add invalid invitees" do
    host = User.create!(name: "Host Name", username: "host_username", password: "abc123", api_key: "valid_api_key")
    invitee1 = User.create!(id: 11, name: "Barbara", username: "leo_fan", password: "test123")
    non_existent_user_id = 9999
  
    viewing_party_params = { name: "My Party", start_time: "2024-10-13 14:00:00", end_time: "2024-10-13 16:00:00", movie_id: 1, movie_title: "Cool Movie" }
    invitees = [invitee1.id, non_existent_user_id]
  
    viewing_party = ViewingParty.create_with_invitees(host, viewing_party_params, invitees)
  
    expect(viewing_party.persisted?).to eq(true)
    expect(viewing_party.users).to include(host, invitee1)
    expect(viewing_party.users).to_not include(User.find_by(id: non_existent_user_id))
  
    invalid_party = UserParty.find_by(user_id: non_existent_user_id)
    expect(invalid_party).to be_nil
  end
end