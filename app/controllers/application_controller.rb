class ApplicationController < ActionController::Base
  protect_from_forgery
  
  after_filter :flash_to_headers
  
  def flash_to_headers
    return unless request.xhr?
    response.headers['X-Message'] = flash_message
    response.headers["X-Message-Type"] = flash_type
    flash.discard # don't want the flash to appear when you reload page
  end
  
  private

  def flash_message
    [:error, :warning, :notice].each do |type|
      return flash[type] unless flash[type].blank?
    end
  end

  def flash_type
    [:error, :warning, :notice].each do |type|
      return type.to_s unless flash[type].blank?
    end
  end
  
end
