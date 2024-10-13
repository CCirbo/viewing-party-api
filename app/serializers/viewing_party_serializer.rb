class ViewingPartySerializer
  include JSONAPI::Serializer
  attributes :name, :start_time, :end_time, :movie_id, :movie_title

  attribute :invitees do |viewing_party|
    viewing_party.user_parties.reject{ |user| user.host }.map do |user_party|
      {
        id: user_party.user.id,
        name: user_party.user.name,
        username: user_party.user.username
      }
    end
  end

  # attribute :invitees do |viewing_party|
  #   viewing_party.users.map do |user|
  #     {
  #       id: user.id,
  #       name: user.name,
  #       username: user.username
  #     }
  #   end
  # end
end