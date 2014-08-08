module Network

  @@tau_self = 0.09
  @@tau_reinforce = 0.15

  def process_fire_from(args)
      @impulse = args[:pulse]
        case  @impulse.tags.include?("$")
          when false
           case self.outputs.first.nil?
             when true
              self.connectors.find_each do |t|
                @node = Node.find(t.output_id)
                 if t.strength >= @node.threshold
                   case @node.pulses.include?(@pulse)
                      when false
                        @node.get_pulse(:pulse => @impulse)
                   end
                 end
              end
           end
          else
           selftags = @impulse.tags.split('$')
           selftags.each do |s|
             tag = s.sub('$','')
              case Node.exists?(:self_tag => tag)
                when true
                  @node = Node.find_by_self_tag(tag)
                    case self.outputs.include?(@node)
                      when true
                       @node.get_pulse(:pulse => @impulse)
                        case self.inputs.include?(Node.find_by_self_tag(tag))
                          when false
                            @synapse = @node.connectors.build
                            @synapse.update_attributes(:strength => 0.5, :output_id => self.id)
                        end
                      when false
                        case self.inputs.include?(Node.find_by_self_tag(tag))
                          when false
                            @synapse = @node.connectors.build
                            @synapse.update_attributes(:strength => 0.5, :output_id => self.id)
                        end

                    end
              end
            end
         end
  end


  def modify_self(args)
    @impulse = args[:pulse]
        pulses = Pulse.where("created_at >= ? AND
                              pulser_type = ? AND
                              pulser != ?",
                             1.day.ago.utc, 'Node', self.id)
        if pulses
        hashtag_regex = /\b#\w\w+/
        pulses.find_each do |p|
          common = @impulse.tags.split(hashtag_regex) & p.tags.split(hashtag_regex)
          if common.length > 0
          if self.outputs.include?(Node.find(p.pulser))
              @synapse = self.connectors.find_by_output_id(p.pulser)
                 if @synapse.updated_at < 1.minute.ago.utc
                   new_strength = @synapse.strength * ((1 - @@tau_self) + (@@tau_self*(1 + common.length)))
                    if new_strength > 1
                      new_strength = 1
                    end
                   @synapse.update_attributes(:strength => new_strength)
                 end
          else
              @synapse = self.connectors.build
              @synapse.update_attributes(:strength => 0.5, :output_id => p.pulser)
          end
        end
      end
    end
  end


  def modify_reinforcement(args)
      @impulse = args[:pulse]
      @rating = args[:rating]
      if Node.find(@impulse.pulser).outputs.include?(self)
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
    if new_strength < 0.5
      @synapse.delete
    end
  end

end
