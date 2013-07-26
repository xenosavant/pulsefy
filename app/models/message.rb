class Message < ActiveRecord::Base

  belongs_to :conversation
  attr_accessible :subject, :body, :sender, :recipient, :read

end
