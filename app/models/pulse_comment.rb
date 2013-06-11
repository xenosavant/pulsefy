class PulseComment < ActiveRecord::Base
  # To change this template use File | Settings | File Templates.

belongs_to :pulse, :counter_cache => true
attr_accessor :comment, :commenter


end