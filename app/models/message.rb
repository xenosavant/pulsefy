class Message < ActiveRecord::Base

  belongs_to :convo
  attr_accessible :sender, :recipient, :read

end
