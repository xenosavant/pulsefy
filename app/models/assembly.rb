#require 'carrierwave/orm/activerecord'

class Assembly < ActiveRecord::Base

   mount_uploader :avatar, AvatarUploader
   attr_accessible :avatar, :info, :title, :founder,
                   :crop_x, :crop_y, :crop_h, :crop_w
   after_update :reprocess_avatar, :if => :cropping?
   has_and_belongs_to_many :nodes
   has_and_belongs_to_many :pulses
   validates :info, :length => { :maximum => 500 }
   validates :title, :presence => true, :uniqueness => {:scope => :founder}
   include Network

   def reprocess_avatar
     self.avatar.cache_stored_file!
     self.avatar.recreate_versions!
   end

end

