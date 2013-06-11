module Network

  @@tau_self = 0.05
  @@tau_reinforce = 0.1


    def process_fire_from(args)
      pulse = args[:pulse]
      if !self.connectors.empty?
      self.connectors.find_each do |t|
          if t.strength >= Node.find(t.output_node).threshold
            Node.find(t.output_node).get_pulse(:pulse => pulse)
          end
      end
      end
    end

  def modify_self(args)
    impulse = args[:pulse]
    collection = Pulse.where("created_at >= ? AND pulser_type == ? AND pulser != ?",
                          1.day.ago.utc, 'Node', self.id)
    collection.find_each do |p|
      common = impulse.content.scan(/\B#\w\w+/) & p.content.scan(/\B#\w\w+/)
      if common.length > 0
        if !self.connectors.find_by_output_node(p.pulser).nil?
          @synapse = self.connectors.find_by_output_node(p.pulser)
          if @synapse.updated_at < 1.minute.ago.utc
            new_strength = (@synapse.strength * (1 - @@tau_self)) + (@@tau_self * common.length)
            if new_strength > 1
              new_strength = 1
            end
            @synapse.strength = new_strength
            @synapse.save
          end
        else
          @synapse = self.connectors.build
          @synapse.update_attributes!(:output_node => p.pulser, :strength => 0.4 )
        end
      end
    end
  end

    def modify_reinforcement(args)
      pulse = args[:pulse]
      rating = args[:rating]
      if self.connectors.where(:output_node => pulse.pulser).exists?
        synapse = self.connectors.where(:output_node => pulse.pulser)
        synapse.strength *= ((1-@@tau_reinforce) + (@@tau_reinforce*rating))
        if synapse.strength < 0
          synapse.strength = 0
        if synapse.strength > 1
          synapse.strength = 1
        end
        end
        synapse.strength.save
      end
    end
end
