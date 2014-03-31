#require 'carrierwave/orm/activerecord'

class Assembly < ActiveRecord::Base

   mount_uploader :avatar, AvatarUploader
   attr_accessible :avatar, :info, :title, :founder,
                   :crop_x, :crop_y, :crop_h, :crop_w
   attr_accessor :width, :height
   after_update :reprocess_avatar, :if => :cropping?
   has_and_belongs_to_many :nodes
   has_and_belongs_to_many :pulses
   validates :info, :length => { :maximum => 500 }
   validates :title, :presence => true, :uniqueness => {:scope => :founder}
   validate :check_avatar_dimensions
   include Network

   def reprocess_avatar
     self.avatar.recreate_versions!
   end

   def check_avatar_dimensions
     case self.avatar.nil?
       when false
         if !self.width.nil? and !self.height.nil?
           @width = self.width
           @height = self.height
           if @width < 300 || @height < 300
             errors.add :avatar, 'Dimensions of uploaded image must be not less than 300x300 pixels.'
           end
           if self.width / self.height > 1.6
             errors.add :avatar, 'Aspect ratio of uploaded image must be less than 1.6.'
           end
         end
     end
   end

   def avatar_geometry
     img = Magick::Image::read(self.avatar.url).first
     @geometry = {:width => img.columns, :height => img.rows }
   end

   def cropping?
     !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
   end


end

