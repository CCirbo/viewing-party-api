class ViewingParty < ApplicationRecord
  has_many :user_parties
  has_many :users, through: :user_parties

  validates :name, :start_time, :end_time, :movie_id, :movie_title, presence: true
  
  def self.create_with_invitees(host, viewing_party_params, invitees)
    viewing_party = host.viewing_parties.create(viewing_party_params)
    host_party = UserParty.where(viewing_party_id:viewing_party.id).where(user_id:host.id)
    host_party.update(host:true)
    if viewing_party.persisted?
      invitees.each do |invitee_id|
        viewing_party.user_parties.create(user_id: invitee_id, viewing_party_id: viewing_party.id)
      end
    end
    viewing_party
  end

  def invitees
    users.joins(:user_parties).where(user_parties: { host: false }).distinct
  end
end