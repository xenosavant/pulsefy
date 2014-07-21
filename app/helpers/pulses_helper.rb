module PulsesHelper

  def return_pulser(pulse_id)
   temp_pulse = Pulse.find(pulse_id)
   @pulser = Node.find(temp_pulse.pulser)
  end

end
