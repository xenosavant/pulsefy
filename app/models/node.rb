class Node < ActiveRecord::Base

  mount_uploader :avatar, AvatarUploader
  attr_accessible :username, :email, :info, :threshold, :password, :password_confirmation, :avatar
  has_secure_password
  before_save { |node| node.email = email.downcase }
  before_save :create_remember_token
  validates :username,  :presence => true, :length => { :maximum => 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :format => { :with => VALID_EMAIL_REGEX },
            :uniqueness => { :case_sensitive => false }, :on => :create
  validates :password, :presence => true, :length => { :minimum => 6 }, :on => :create
  validates :password_confirmation, :presence => true, :on => :create
  has_and_belongs_to_many :pulses
  has_and_belongs_to_many :assemblies
  has_many :connectors, :foreign_key => 'input_id', :dependent => :destroy
  has_many :outputs, :through => :connectors
  has_many :reverse_relationships, :foreign_key => 'output_id',
      :class_name =>  'Connector', :dependent =>  :destroy
  has_many :inputs, :through => :reverse_relationships
  has_many :votes
  has_one  :inbox

  include Network



  def get_pulse(args)
    @impulse = args[:pulse]
    if @impulse.pulser != self.id and !self.pulses.include?(@impulse)
      process_fire_from(:pulse => @impulse)
      self.pulses << @impulse
      @impulse.increment!(:depth)
    end
  end

  def comment_pulse(args)
    pulse = args[:pulse]
    pulse.pulse_comments.create(:comment => args[:comment], :commenter => self.id )
  end

  def rate_pulse(args)
    @impulse = args[:pulse]
    @rating = args[:rating]
    @vote = self.votes.build
    if @rating == true
      @impulse.increment!(:degradations)
      modify_reinforcement(:pulse => @impulse, :rating => 1)
      @vote.update_attributes(:rating => 1, :pulse_id => @impulse.id)
    else
      @impulse.increment!(:reinforcements)
      modify_reinforcement(:pulse => @impulse, :rating => 0)
      @vote.update_attributes(:rating =>  0, :pulse_id => @impulse.id)
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










