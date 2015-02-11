module PulseCommentsHelper

  def avatar_node(commenter)
    @avatar_node = Node.find(commenter)
  end

end
