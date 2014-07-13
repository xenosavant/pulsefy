class Crop

  include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  @queue = :crop_queue

  def self.perform(options)
    @class = options['class']
    @id = options['id']
    case @class
      when 'Node'
        @model = Node.find(@id)
      when 'Assembly'
        @model = Assembly.find(@id)
    end
   image = MiniMagick::Image.open(@model.avatar.url)

    x = @model.crop_x.to_s
    y = @model.crop_y.to_s
    w = @model.crop_w.to_s
    h = @model.crop_h.to_s

    image.crop(w + 'x' + h + '+' + x + '+' + y)
    #img.crop(model.crop_x.to_i,model.crop_y.to_i,model.crop_h.to_i,model.crop_w.to_i)
    image
  end

end
