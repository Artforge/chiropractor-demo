class PostsController < InheritedResources::Base
  respond_to :html, :xml, :json, :js
  
  def pick(hash, *keys)
    filtered = {}
    hash.each do |key, value| 
      filtered[key.to_sym] = value if keys.include?(key.to_sym) 
    end
    filtered
  end
  
  def create
    @post = Post.new(pick(params, :user_id, :title, :content))
    create! do |format|
      format.html{render :nothing => true}
      format.js {render :json => @post.to_json(:include => :user)}
    end
  end
  
  def update
    @post = Post.find(params[:id])
    @post.update_attributes(pick(params, :user_id, :title, :content))
    update! do |format|
      format.html{}
      format.js {render :json => @post.to_json(:include => :user)}
    end
  end
  
  def destroy
    destroy! do |success, failure|
      failure.html { render :action => "edit" }
      failure.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      failure.js   { render :json => @post.errors.to_json}
      success.js   { render :json => 'posts_controller.destroy(' + @post.id.to_s + ');'}
    end
  end
  
  def index
    @post = Post.new({:id => 0})
    index! do |format|
      format.html{}
      format.js {render :json => @posts.to_json(:include => :users)}
    end
  end
  
end
