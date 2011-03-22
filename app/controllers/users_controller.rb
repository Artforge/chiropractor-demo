class UsersController < InheritedResources::Base
  respond_to :html, :xml, :json, :js
  
  def pick(hash, *keys)
    filtered = {}
    hash.each do |key, value| 
      filtered[key.to_sym] = value if keys.include?(key.to_sym) 
    end
    filtered
  end
  
  def create
    @user = User.new(pick(params, :email, :name, :biography, :date_of_birth, :favorite_color))
    create! do |format|
      format.html{render :nothing => true}
      format.js {render :json => @user.to_json}
    end
  end
  
  def update
    @user = User.find(params[:id])
    @user.update_attributes(pick(params, :email, :name, :biography, :date_of_birth, :favorite_color))
    if params['Filedata']
      @user.avatar = params['Filedata']
      @user.save
    end
    update! do |format|
      format.html{render :json => @user.to_json(:methods => [:avatar_thumbnail_url,:avatar_url])}
      format.js {render :json => @user.to_json(:methods => [:avatar_thumbnail_url,:avatar_url])}
    end
  end
  
  def destroy
    destroy! do |success, failure|
      failure.html { render :action => "edit" }
      failure.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      failure.js   { render :json => @user.errors.to_json}
      success.js   { render :json => 'users_controller.destroy(' + @user.id.to_s + ');'}
    end
  end
  
  def index
    index! do |format|
      format.html{}
      format.js {render :json => @users.to_json(:methods => [:avatar_thumbnail_url,:avatar_url])}
    end
  end
  
end
