class Pulse < ActiveRecord::Base

  has_and_belongs_to_many :nodes
  has_and_belongs_to_many :assemblies
  has_many :pulse_comments, :dependent => :destroy
  attr_accessible :depth, :content, :reinforcements, :degradations, :pulser_type, :pulser,
                  :tags, :link, :embed_code, :thumbnail, :link_type, :url, :headline
  validates :content, :presence => true, :length => { :maximum => 300 }
  validates :tags, :length => { :maximum => 50 }
  validates :headline, :length => { :maximum => 50 }
  validates :link, :allow_blank => true, :format => { :with => URI::regexp(%w(http https)), :message => "Valid URL required"}
  default_scope order 'pulses.created_at DESC'

  def defaults
    @reinforcements = 0
    @degradations = 0
    @depth = 0
  end

end
