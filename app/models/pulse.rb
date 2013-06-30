class Pulse < ActiveRecord::Base

  has_and_belongs_to_many :nodes
  has_and_belongs_to_many :assemblies

  has_many :pulse_comments, :dependent => :destroy
  attr_accessible :depth, :content, :reinforcements, :degradations, :pulser_type, :pulser,
                  :tags, :link, :embed_code, :thumbnail, :link_type, :url
  validates :content, :presence => true, :length => { :maximum => 140 }
  default_scope order 'pulses.created_at DESC'

 def update_embed
   api = Embedly::API.new
   @embed = api.oembed :url => self.link
   self.update_attributes(:embed_code => @embed[0].html, :thumbnail => @embed[0].thumbnail_url,
                          :link_type => @embed[0].type, :url => @embed[0].url)
 end

  def defaults
    @reinforcements = 0
    @degradations = 0
    @depth = 0
  end

end
