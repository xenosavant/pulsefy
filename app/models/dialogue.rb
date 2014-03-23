class Dialogue < ActiveRecord::Base

  belongs_to :node
  attr_accessible :receiver_id, :active
  has_many :convos, :dependent => :destroy

  default_scope order 'dialogues.updated_at DESC'

end
