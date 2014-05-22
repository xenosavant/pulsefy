module InboxesHelper
  include SessionsHelper

  def update_unreads(args)
    @node = args[:node]
     tmp = 0;
     @node.dialogues.find_each do |d|
        d.convos.find_each do  |c|
        if c.interrogator_id == @node.id
          if c.unread_interrogator
            tmp = tmp + 1
          end
        else
          if c.unread_interlocutor
            tmp = tmp + 1
          end
        end
      end
     end
    @node.update_attribute(:unreads => tmp)
  end

  def update_dialogues(args)
    @node = args[:node]
    @node.dialogues.find_each do |d|
      tmp = 0
      d.convos.find_each do  |c|
        if c.interrogator_id == @node.id
          if c.unread_interrogator
            tmp = tmp + 1
          end
        else
          if c.unread_interlocutor
            tmp = tmp + 1
          end
        end
      end
    case d.sender_id == @node.id
      when true
       if tmp != 0
         d.unread_sender = true
       else
         d.unread_sender = false
       end
      else
        if tmp != 0
         d.unread_receiver = true
        else
         d.unread_receiver = false
      end
    end
   end
  end



end
