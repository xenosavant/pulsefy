module PulsesHelper

  def pulser(pulse_id)
   @pulse = Pulse.find(pulse_id)
   @pulser = Node.find(@pulse.pulser)
  end

end
