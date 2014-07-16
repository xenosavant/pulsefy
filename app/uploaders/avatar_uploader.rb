# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  before :cache, :capture_size_before_cache # callback, example here: http://goo.gl/9VGHI
  # Choose what kind of storage to use for this uploader:
  storage :fog

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the directory where uploaded files will be stored.

  def store_dir
    "avatars/#{model.class.to_s.underscore}/#{model.id}/"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def capture_size_before_cache(new_file)
    if model.width.nil? || model.height.nil?
      model.width, model.height = `identify -format "%wx %h" #{new_file.path}`.split(/x/).map { |dim| dim.to_i }
    end
  end

  # Create different versions of your uploaded files:

  def manualcrop
    return unless model.cropping?
     img = MiniMagick::Image.open(model.avatar.url)
     manipulate! do |img|

       x = model.crop_x.to_s
       y = model.crop_y.to_s
       w = model.crop_w.to_s
       h = model.crop_h.to_s

     img.crop(w + 'x' + h + '+' + x + '+' + y)
     #img.crop(model.crop_x.to_i,model.crop_y.to_i,model.crop_h.to_i,model.crop_w.to_i)
     img
    end
  end

  version :large do
    process :resize_to_limit => [500, 1000]
  end

  version :profile do
     process :manualcrop
     process :resize_to_fit => [300, 300]
   end

  version :thumb do
    process :manualcrop
    process :resize_to_fit => [100, 100]
  end

  version :micro do
    process :manualcrop
    process :resize_to_fit => [50, 50]
  end

  version :nano do
    process :manualcrop
    process :resize_to_fit => [25, 25]
  end


  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
     "image.jpg" if original_filename
  end

end
