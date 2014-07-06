class Mail
  @queue = :mail_queue

  def self.perform(node_id)
    @node = Node.find(args[node_id])
    tmp = 0
    @node.dialogues.find_each do |d|
      d.convos.find_each do  |c|
        case c.interrogator_id
          when @node.id
            case c.unread_interrogator
              when true
                tmp = tmp + 1
            end
          else
            case c.unread_interlocutor
              when true
                tmp = tmp + 1
            end
        end
      end
    end
    @node.update_attributes(:unreads => tmp)
  end

end