require 'lib/network'

class Node < ActiveRecord::Base
  #  The node class represents the basic object model for an individual (non-commercial) user
  #  It's responsibility is to manage pulse firing and receiving
  #
  attr_accessible :username, :email, :info, :threshold, :password, :password_confirmation
  has_secure_password
  before_save { |node| node.email = email.downcase }
  before_save :create_remember_token
  validates :username,  :presence => true, :length => { :maximum => 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :format => { :with => VALID_EMAIL_REGEX },
            :uniqueness => { :case_sensitive => false }, :on => :create
  validates :password, :presence => true, :length => { :minimum => 6 }
  validates :password_confirmation, :presence => true, :on => :create
  has_and_belongs_to_many :pulses
  has_many :connectors


  include Network


  def fire_pulse(args)
    @impulse = args[:pulse]
    #process_fire_from(:pulse => @impulse)
    modify_self(:pulse => @impulse)
  end


  def get_pulse(args)
    impulse = args[:pulse]
    if impulse.pulser != self.id
      process_fire_from(:pulse => impulse)
      self.pulses << impulse
      impulse.increment!(:depth)
    end
  end

  def comment_pulse(args)
    pulse = args[:pulse]
    pulse.pulse_comments.create(:comment => args[:comment], :commenter => self )
  end

  def rate_pulse(args)
    pulse = args[:pulse]
    rating = args[:rating]
    if rating == 0
      pulse.increment!(:degradations)
      modify_reinforcement(:pulse => pulse, :rating => rating)
    else
      pulse.increment!(:reinforcements)
      modify_reinforcement(:pulse => pulse, :rating => rating)
    end

  end

  def defaults
    @threshold = 0.5
    @admin = false
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.base64.tr('+/', '-_')
    end

end










