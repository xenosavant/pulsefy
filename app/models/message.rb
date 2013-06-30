class Message < ActiveRecord::Base

  belongs_to :inbox
  attr_accessible :content

end
