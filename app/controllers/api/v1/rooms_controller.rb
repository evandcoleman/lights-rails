class Api::V1::RoomsController < Api::V1::ApiController
	before_filter :api_session_token_authenticate!

	def show
		if params[:id]
			room = Room.find_by_id(params[:id])
			render :json => room.to_json(include: :x10_devices), :code => :ok
		else
			render :json => Room.all(include: :x10_devices).to_json(include: :x10_devices)
		end
	end

end