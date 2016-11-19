class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def set_domain
    @smart_light_control_domain = ENV['SMART_LIGHT_CONTROL_DOMAIN']
  end
end
