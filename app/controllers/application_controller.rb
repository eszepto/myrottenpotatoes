class ApplicationController < ActionController::Base
  
  protect_from_forgery with: :exception
  before_action :set_current_user, :authenticate!, :set_config
  
  def set_current_user
      @current_user = Moviegoer.find_by(id: session[:user_id])
  end
  
  require 'themoviedb'
  Tmdb::Api.key("cda0083c781b5bb291264c42c7790eba")

  def set_config
  	@configuration = Tmdb::Configuration.new
  end

  protected
  
  def authenticate!
      unless @current_user
          redirect_to login_path
      end
  end
end