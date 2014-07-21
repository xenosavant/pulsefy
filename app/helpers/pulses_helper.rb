module PulsesHelper

  def current_pulser(pulse_id)
   temp_pulse = Pulse.find(pulse_id)
   @current_pulser = Node.find(temp_pulse.pulser)
  end

end
