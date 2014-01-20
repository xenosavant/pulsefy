class Convo < ActiveRecord::Base

  belongs_to :dialogue
  has_many :messages
  attr_accessible :interval, :active, :read

end