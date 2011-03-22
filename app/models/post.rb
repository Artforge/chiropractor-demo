class Post < ActiveRecord::Base
  belongs_to :user
  self.include_root_in_json = false
  
end
