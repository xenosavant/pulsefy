class Connector < ActiveRecord::Base

  belongs_to :output, :class_name => 'Node'
  belongs_to :input,  :class_name => 'Node'
  attr_accessible :strength, :output_id

end