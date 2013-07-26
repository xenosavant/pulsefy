class Dialogue < ActiveRecord::Base

  has_and_belongs_to_many :inboxes
  has_many :messages

end
