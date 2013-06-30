class Assembly < ActiveRecord::Base

   mount_uploader :avatar, AvatarUploader
   attr_accessible :title, :info, :founder, :avatar
   has_and_belongs_to_many :nodes
   has_and_belongs_to_many :pulses

   include Network

end

