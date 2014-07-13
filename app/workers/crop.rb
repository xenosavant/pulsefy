class Crop

  include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  @queue = :crop_queue

  def self.perform(options)
    @class_id = options[:class_id]
    @model_id = options[:model_id]
    case @class_id
      when 'Node'
        @model = Node.find(@class_id)
      when 'Assembly'
        @model = Assembly.find(@class_id)
    end
   img = MiniMagick::Image.open(@model.avatar.url)
   manipulate! do |img|

    x = @model.crop_x.to_s
    y = @model.crop_y.to_s
    w = @model.crop_w.to_s
    h = @model.crop_h.to_s

    img.crop(w + 'x' + h + '+' + x + '+' + y)
    #img.crop(model.crop_x.to_i,model.crop_y.to_i,model.crop_h.to_i,model.crop_w.to_i)
    img
    end
  end
end
