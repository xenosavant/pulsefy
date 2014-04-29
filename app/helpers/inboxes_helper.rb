module InboxesHelper

  def update_unreads
     @node = current_node
     tmp = 0;
     @node.dialogues.find_each do |d|
        d.convos.find_each do  |c|
          if c.unread
            tmp = tmp + 1
          end
        end
     end
    @node.unreads = tmp;
  end

end
