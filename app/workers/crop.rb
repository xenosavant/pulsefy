class Crop

  include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  @queue = :crop_queue

  def self.perform(node_id)
    @node = Node.find(node_id)
    @node.reprocess_avatar!
  end

end
