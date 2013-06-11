class Pulse < ActiveRecord::Base

  has_and_belongs_to_many :nodes
  has_many :pulse_comments , :dependent => :destroy
  attr_accessible :depth, :content, :reinforcements, :degradations, :pulser_type, :strength
  #validates :pulser, :presence => true
  validates :content, :presence => true, :length => { :maximum => 140 }
  default_scope order 'pulses.created_at DESC'


  def defaults
    @reinforcements = 0
    @degradations = 0
    @depth = 0
  end

end
