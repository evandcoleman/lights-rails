class Api::V1::PresetsController < Api::V1::ApiController
	before_filter :api_session_token_authenticate!

	def create
		@preset = Preset.new(:name => params[:name], :owner => current_user.id)

		if @preset.save
			render :json => @preset, :code => :ok
		else
			render :json => {}, :code => :unprocessable_entity
		end
	end

	def add_event
		event = Event.new(params[:event])

		if event.save
			render :json => @event, :code => :ok
		else
			render :json => {}, :code => :unprocessable_entity
		end
	end

	def show
		render :json => {:presets => Preset.all}
	end

	def update
		if Preset.update(params[:id], params[:events])
    	render :json => Preset.find_by_id(params[:id]), :status => :ok
    else
    	render :json => {}, :code => :unprocessable_entity
		end
	end
end