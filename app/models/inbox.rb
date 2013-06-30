class Inbox < ActiveRecord::Base

  belongs_to :node
  has_many :messages

end
