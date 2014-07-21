module PulsesHelper

  def pulser(pulse)
   @pulser = Node.find(pulse.pulser)
  end

end
