class Api::V1::ViewingPartiesController < ApplicationController
  def create
    host = User.find_by(api_key: params[:api_key])
   
    if host.nil? 
      return render json: ErrorSerializer.format_error(ErrorMessage.new("Invalid API key", 401)), status: :unauthorized
    end

      viewing_party = host.viewing_parties.create(viewing_party_params)

      if viewing_party.persisted?
        invite_guests(viewing_party)
        render json: ViewingPartySerializer.new(viewing_party), status: :created
      else
        render json: ErrorSerializer.format_error(ErrorMessage.new(viewing_party.errors.full_messages.to_sentence, 422)),  status: :unprocessable_entity
      end
    end

  private

  def viewing_party_params
    params.permit(:name, :start_time, :end_time, :movie_id, :movie_title)
  end
  
  def invite_guests(viewing_party)
    valid_invitees = params[:invitees].map { |user_id| User.find_by(id: user_id) }.compact
    valid_invitees.each { |invitee| UserParty.create!(user_id: invitee.id, viewing_party_id: viewing_party.id, host: false) }
  end
end
