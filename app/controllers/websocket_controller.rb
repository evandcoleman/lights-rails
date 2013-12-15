class WebsocketController < WebsocketRails::BaseController

	def initialize_session
    # perform application setup here
    controller_store[:current_state] = ""
  end

  def client_connected
  	puts "client connected"
  end

  def client_disconnected
    puts "client disconnected"
  end

  def command
  	puts message
    maybe_save_state message
    record_metric message
  	broadcast_message :command, message
  end

  def command_collection
    # TODO: Pickup current state from presets
  	puts message
  	broadcast_message :command_collection, message
  end

  def current_state
    puts controller_store[:current_state]
    broadcast_message :current_state, controller_store[:current_state]
  end

  def schedule_updated
    puts "sending scheduled events"
    puts message
    broadcast_message :schedule_updated, {:zone => message[:zone], :events => Event.where(:zone => message[:zone])}
  end

  def toggle_event_state
    puts "toggling event state"
    puts message
    event = Event.find_by_id(message[:id])
    event.state = !event.state
    event.save
  end

  def maybe_save_state(message=nil)
    if message
      if message[:eventType] != 9
        puts "saving current state"
        controller_store[:current_state] = message
      end
    end
  end

  def record_metric(message=nil)
    # only record X10 events for now

    if message[:eventType] == 9
      device = X10device.where(:deviceId => message[:device], :houseCode => message[:houseCode], :zone => message[:zone])
      deviceName = device.name.gsub(/ /, '_')
      if message[:command] == 0
        ::NewRelic::Agent.increment_metric("Custom/#{deviceName}/off")
      elsif message[:command] == 1
        ::NewRelic::Agent.increment_metric("Custom/#{deviceName}/on")
      end
    end
  end
end
