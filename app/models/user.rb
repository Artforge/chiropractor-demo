class User < ActiveRecord::Base
  has_many :posts
  self.include_root_in_json = false
  
  has_attached_file :avatar, 
    :default_url => "/system/default_avatars/:style/anonymous.png",
    :styles => { :original => "1024x1024>", 
    :large => "300x300>", 
    :medium => "100x100>", 
    :small => "48x48>"}
    
  def avatar_thumbnail_url
    self.avatar.url(:small)
  end
  
  def avatar_url
    self.avatar.url
  end
  
end
