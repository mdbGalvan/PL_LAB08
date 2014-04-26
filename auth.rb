require 'omniauth-oauth2'
require 'omniauth-google-oauth2'
require 'omniauth-github'
require 'omniauth-facebook'
require 'omniauth-twitter'

use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  # http://richonrails.com/articles/google-authentication-in-ruby-on-rails
  provider :google_oauth2, config['identifier_gg'], config['secret_gg']
  # https://github.com/mkdynamic/omniAuth-facebook
  # https://www.youtube.com/watch?v=YAcg6ejylL0
  provider :facebook, config['identifier_fb'], config['secret_fb']
  # https://www.youtube.com/watch?v=rWNYZOT0a6o
  provider :twitter, config['identifier_tw'], config['secret_tw']
end

get '/auth/:name/callback' do
  puts "\n**********************@auth/:name/callback*********************"
  session[:auth] = @auth = request.env['omniauth.auth']
  session[:name] = @auth['info'].name
  session[:image] = @auth['info']['image']
  session[:email] = @auth['info']['email']
  session[:url] = @auth['extra']['raw_info']['link']
  puts "params = #{params}"
  puts "@auth.class = #{@auth.class}"
  puts "@auth info = #{@auth['info']}"
  puts "@auth info class = #{@auth['info'].class}"
  puts "@auth info name = #{@auth['info'].name}"
  puts "@auth info email = #{@auth['info'].email}"
  #puts "\n---------------@auth:Auth Hash----------------------------------"
  #PP.pp @auth
  #puts "*************@auth.methods*****************"
  #PP.pp @auth.methods.sort
  flash[:notice] = %Q{<div class="welcome">Welcome, #{@auth['info'].name}</div>}
  redirect '/'
end

get '/auth/failure' do
  flash[:notice] = params[:message] 
  redirect '/'
end

