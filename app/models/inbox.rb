class Inbox < ActiveRecord::Base

  belongs_to :node
  has_and_belongs_to_many :dialogues

end
