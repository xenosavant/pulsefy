class Node < ActiveRecord::Base


  mount_uploader  :avatar, AvatarUploader
  attr_accessible :username, :email, :info, :threshold,
                  :password, :password_confirmation, :avatar, :self_tag,
                  :crop_x, :crop_y, :crop_w, :crop_h, :remember_token,
                  :hub, :admin, :verified, :self_tag, :width,
                  :height
  has_secure_password
  before_save { |node| node.email = email.downcase }
  before_create :create_remember_token
  validates :username,  :presence => true, :length => { :maximum => 20 }
  validate :check_avatar_dimensions
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :format => { :with => VALID_EMAIL_REGEX },
            :uniqueness => { :case_sensitive => false }, :on => :create
  validates :password, :presence => true, :length => { :minimum => 6 }, :on => :create
  validates :password_confirmation, :presence => true, :on => :create
  validates :info, :length => { :maximum => 2000 }
  has_and_belongs_to_many :pulses
  has_and_belongs_to_many :assemblies
  has_and_belongs_to_many :dialogues
  has_many :connectors, :foreign_key => 'input_id', :dependent => :destroy
  has_many :outputs, :through => :connectors
  has_many :reverse_relationships, :foreign_key => 'output_id',
      :class_name =>  'Connector', :dependent =>  :destroy
  has_many :inputs, :through => :reverse_relationships
  has_many :votes
  has_many :repulses
  has_many :unreads

  include Network
  include SessionsHelper

  def fire_pulse(args)
    @impulse = args[:pulse]
    process_fire_from(:pulse => @impulse)
    modify_self(:pulse => @impulse)
  end

  def re_fire(args)
    @impulse = args[:pulse]
    @repulse = self.repulses.build
    process_fire_from(:pulse => @impulse)
    modify_self(:pulse => @impulse)
    @repulse.update_attributes(:pulse_id => @impulse.id)
    @impulse.increment!(:refires)
  end

  def get_pulse(args)
    @impulse = args[:pulse]
    if @impulse.pulser != self.id and !self.pulses.include?(@impulse)
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
    if @rating == 0
      @impulse.increment!(:degradations)
      modify_reinforcement(:pulse => @impulse, :rating => 0)
      @vote.update_attributes(:rating => 0, :pulse_id => @impulse.id)
      self.pulses.delete(@impulse)
    else
      @impulse.increment!(:reinforcements)
      modify_reinforcement(:pulse => @impulse, :rating => 1)
      @vote.update_attributes(:rating =>  1, :pulse_id => @impulse.id)
    end
  end

  def defaults
    @threshold = 0.5
    @unreads = 0
    @admin = false
    @hub = false
    @verified = false
    @width = 300
    @height = 300
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['username LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end

  def reprocess_avatar
    self.avatar.cache_stored_file!
    self.avatar.recreate_versions!
  end

  def sign_in_self
     sign_in(self)
  end

  def check_avatar_dimensions
    case self.avatar.nil?
      when false
        if !self.width.nil? and !self.height.nil?
        @width = self.width
        @height = self.height
        if self.width / self.height > 1.6
        errors.add :avatar, 'Aspect ratio of uploaded image must be less than 1.6.'
        end
        if self.width / self.height < 0.5
          errors.add :avatar, 'Aspect ratio of uploaded image must be greater than 0.5.'
        end
        if self.avatar.file.size.to_f/(1000*1000) > 1000.kilobytes
          errors.add :avatar, 'You cannot upload a file greater than 1 megabyte'
        end
      end
    end
  end

  def avatar_geometry
    img = Magick::Image::read(self.avatar.url).first
    @geometry = {:width => img.columns, :height => img.rows }
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.base64.tr('+/', '-_')
  end

end










