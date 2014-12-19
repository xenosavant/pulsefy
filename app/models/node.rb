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
  validates :self_tag, :uniqueness => { :case_sensitive => false }, :length => { :minimum => 6 }, :allow_blank => {:on => :create}
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

  def search(search)
    case search
      when true
      Node.where('username LIKE ?', "%#{search}%").all
      else
      Node.all
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

  def init
    sign_in(self)
    self.pulses << Pulse.find(116)
    @synapse = Node.find(1).connectors.build
    @synapse.update_attributes(:strength => 0.5, :output_id => self.id)
  end

  def initialize_convo(receiver)
    if receiver !=  self.id and receiver != 0 and !receiver.nil?
      @node = Node.find(receiver)
      case self.dialogues.where(:receiver_id => @node.id).exists? or self.dialogues.where(:sender_id => @node.id).exists?
        when false
          @dialogue = self.dialogues.build
          @dialogue.update_attributes(:sender_id => self.id, :receiver_id => @node.id, :unread_receiver => true, :unread_sender => false)
          @node.dialogues << @dialogue
          self.dialogues << @dialogue
        when true
          case self.dialogues.where(:receiver_id => @node.id).exists?
            when true
              @dialogue = self.dialogues.where(:receiver_id => @node.id).first
              @dialogue.update_attributes(:unread_receiver => true)
            when false
              @dialogue = self.dialogues.where(:sender_id => @node.id).first
              @dialogue.update_attributes(:unread_sender => true)
            else
              @dialogue = self.dialogues.build
              @dialogue.update_attributes(:sender_id => self.id, :receiver_id => @node.id, :unread_receiver => true, :unread_sender => false)
              @node.dialogues << @dialogue
              self.dialogues << @dialogue
          end
      end
      @dialogue.save
      case @dialogue.convos.any?
        when true
          case @dialogue.convos.where(:active => true).last.nil?
            when false
              @old_convo = @dialogue.convos.where(:active => true).last
              case @old_convo.messages.last.nil?
                when false
                  if Time.now - @old_convo.messages.last.created_at > 24.hours
                    @old_convo.update_attributes(:active => false)
                    @old_convo.save
                    @convo = @dialogue.convos.build
                    @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => self.id,
                                             :unread_interrogator => false, :unread_interlocutor => true, :active => true)
                    @initialize_convo = @convo
                    @convo.save
                  else
                    @convo = @dialogue.convos.where(:active => true).last
                    if @convo.interlocutor_id == self.id
                      @convo.update_attributes(:unread_interrogator => true)
                    else
                      @convo.update_attributes(:unread_interlocutor => true)
                    end
                    @convo.save
                    @initialize_convo = @convo
                  end
                else
                  @convo = @dialogue.convos.where(:active => true).last
                  if @convo.interlocutor_id == self.id
                    @convo.update_attributes(:unread_interrogator => true)
                  else
                    @convo.update_attributes(:unread_interlocutor => true)
                  end
                  @convo.save
                  @initialize_convo = @convo
              end
            else
              @convo = @dialogue.convos.build
              @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => self.id,
                                       :unread_interrogator => false, :unread_interlocutor => true, :active => true)
              @convo.save
              @initialize_convo = @convo
          end
        else
          @convo = @dialogue.convos.build
          @convo.update_attributes(:interlocutor_id => @node.id, :interrogator_id => self.id,
                                   :unread_interrogator => false, :unread_interlocutor => true, :active => true)
          @convo.save
          @initialize_convo = @convo
      end
      @message = @convo.messages.build(params[:message])
      @message.update_attributes(:read => false, :receiver_id => session[:receiver], :sender_id => current_node.id)
      @unread = Node.find(session[:receiver]).unreads.build
      @unread.update_attributes(:convo_id => @convo.id)
    end
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.base64.tr('+/', '-_')
  end


end










