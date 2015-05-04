class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include TicketsHelper

  alias_method :current_user, :current_staff

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  # CanCan Rails 4 fix
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

private

  def app_params
    params.require(:app).permit(:name, :description, :author, :url_path, :validated, :active, :version)
  end
end
