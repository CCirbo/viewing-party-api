class ViewingPartySerializer
  include JSONAPI::Serializer
  attributes :name, :start_time, :end_time, :movie_id, :movie_title

  attribute :invitees do |viewing_party|
    viewing_party.user_parties.select { |user_party| !user_party.host }.map do |user_party|
      {
        id: user_party.user.id,
        name: user_party.user.name,
        username: user_party.user.username
      }
    end
  end
end