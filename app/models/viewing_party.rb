class ViewingParty < ApplicationRecord
  has_many :user_parties
  has_many :users, through: :user_parties

  validates :name, :start_time, :end_time, :movie_id, :movie_title, presence: true

  # validate :party_duration_cannot_be_less_than_movie_runtime
  # validate :end_time_after_start_time
  
  def self.create_with_invitees(host, viewing_party_params, invitees)
    viewing_party = host.viewing_parties.create(viewing_party_params)
    host_party = UserParty.where(viewing_party_id:viewing_party.id).where(user_id:host.id)
    host_party.update(host:true)
  
    # require 'pry'; binding.pry
    if viewing_party.persisted?
      invitees.each do |invitee_id|
        viewing_party.user_parties.create(user_id: invitee_id, viewing_party_id: viewing_party.id)
      end
    end
    viewing_party
  end
  # def self.create_with_invitees(host, viewing_party_params, invitees)
  #   viewing_party = host.viewing_parties.create(viewing_party_params)
  
  #   # Ensure the host party is set correctly
  #   UserParty.create!(user_id: host.id, viewing_party_id: viewing_party.id, host: true)
  
  #   if viewing_party.persisted?
  #     invitees.each do |invitee_id|
  #       UserParty.create!(user_id: invitee_id, viewing_party_id: viewing_party.id)
  #     end
  #   end
  
  #   viewing_party
  # end
end