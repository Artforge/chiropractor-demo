# require 'rack/utils'
# 
# class FlashSessionCookieMiddleware
#   def initialize(app, session_key = '_session_id')
#     @app = app
#     @session_key = session_key
#   end
# 
#   def call(env)
#     if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/
#       req = Rack::Request.new(env)
#       env['HTTP_COOKIE'] = decode req.params["session_encoded"] unless req.params["session_encoded"].nil?
#     end
#     @app.call(env)
#   end
# 
#   private
# 
#   def decode(s)
#     s.split("x").map{|x| x.to_i.chr}.join
#   end
# end
# 
# Rails.configuration.middleware.insert_before(ActionDispatch::Session::CookieStore, FlashSessionCookieMiddleware, Rails.configuration.secret_token)


## Inside: app/middleware/flash_session_cookie_middleware.rb
require 'rack/utils'
 
class FlashSessionCookieMiddleware
  def initialize(app, session_key = '_session_id')
    @app = app
    @session_key = session_key
  end
 
  def call(env)
    if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/
      params = ::Rack::Request.new(env).params
      env['HTTP_COOKIE'] = [ @session_key, params[@session_key] ].join('=').freeze unless params[@session_key].nil?
    end
    @app.call(env)
  end
end