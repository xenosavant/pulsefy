class PulseComment < ActiveRecord::Base
  # To change this template use File | Settings | File Templates.

belongs_to :pulse, :counter_cache => true
attr_accessible :content, :commenter
validates :content, :presence => true, :length => { :maximum => 140 }
default_scope order 'pulse_comments.created_at ASC'

end