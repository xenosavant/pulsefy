class Request < ActiveRecord::Base
  attr_accessible :sender_id, :receiver_id, :body, :request_type, :dialogue_id
  belongs_to :node
  belongs_to :dialogue
  default_scope order 'requests.created_at DESC'
end
