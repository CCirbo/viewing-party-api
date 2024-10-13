class Api::V1::ViewingPartiesController < ApplicationController
  def create
    host = User.find_by(id: params[:user_id])
    api_key_from_request = params[:api_key]
    # require 'pry'; binding.pry
    # if !host.valid_api_key?
    #   return render json: { error: "Invalid API key" }, status: :unauthorized
    # end
    if host.nil? || !host.valid_api_key?(api_key_from_request)
      return render json: { error: "Invalid API key" }, status: :unauthorized
    end

    viewing_party = ViewingParty.create_with_invitees(host, viewing_party_params, params[:invitees])
    # require 'pry'; binding.pry
    if viewing_party.persisted?
      render json: ViewingPartySerializer.new(viewing_party), status: :created
    else
      render json: { errors: viewing_party.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def viewing_party_params
    params.permit(:name, :start_time, :end_time, :movie_id, :movie_title)
  end
 
end
