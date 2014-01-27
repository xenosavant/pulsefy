class Dialogue < ActiveRecord::Base

  has_and_belongs_to_many :nodes
  has_many :convos
  attr_accessible :latest

end
