module Network

  @@tau_self = 0.09
  @@tau_reinforce = 0.15

  def fire_pulse(args)
    @impulse = args[:pulse]
    process_fire_from(:pulse => @impulse)
    modify_self(:pulse => @impulse)
  end

  def process_fire_from(args)
      @impulse = args[:pulse]
    if self.outputs
      self.connectors.find_each do |t|
        if t.strength >= Node.find(t.output_id).threshold
          Node.find(t.output_id).get_pulse(:pulse => @impulse)
        end
      end
    end
  end


  def modify_self(args)
    @impulse = args[:pulse]
        pulses = Pulse.where("created_at >= ? AND pulser_type = ? AND pulser != ?",
                             1.day.ago.utc, 'Node', self.id)
        if !pulses.empty?
        pulses.find_each do |p|
          common = @impulse.tags.split(',') & p.tags.split(',')
          if common.length > 0
          if !self.connectors.find_by_output_id(p.pulser).nil?
              @synapse = self.connectors.find_by_output_id(p.pulser)
                 if @synapse.updated_at < 1.minute.ago.utc
                   new_strength = @synapse.strength * ((1 - @@tau_self) + (@@tau_self*(1.0 + common.length)))
                    if new_strength > 1
                      new_strength = 1
                    end
                   @synapse.update_attributes(:strength => new_strength)
                 end
          else
              @synapse = self.connectors.build
              @synapse.update_attributes(:strength => 0.4, :output_id => p.pulser)
          end
        end
      end
    end
  end


  def modify_reinforcement(args)
      @impulse = args[:pulse]
      @rating = args[:rating]
      if Node.find(@impulse.pulser).connectors.find_by_output_id(self.id)
        @synapse = Node.find(@impulse.pulser).connectors.find_by_output_id(self.id)
        modify_synapse(:synapse => @synapse, :rating => @rating)
      else
        if self.inputs
          self.inputs.find_each do |t|
            if t.pulses.include?(@impulse)
              if t.outputs.include?(self)
               @synapse = t.connectors.find_by_output_id(self.id)
               modify_synapse(:synapse => @synapse, :rating => @rating)
              end
            end
          end
        end
      end
  end


  def modify_synapse(args)
    @synapse = args[:synapse]
    @rating = args[:rating]
    new_strength = @synapse.strength * ((1-@@tau_reinforce) + (@@tau_reinforce*2*@rating))
      if @synapse.strength < 0
        new_strength = 0
      end
      if @synapse.strength > 1
        new_strength = 1
      end
    @synapse.update_attributes(:strength => new_strength)
  end

end
