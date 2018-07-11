class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:index]
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_admin, if: :current_user
  def configure_permitted_parameters
    added_attrs = [:email, :name]
    devise_parameter_sanitizer.permit(:sign_in, keys: added_attrs)
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
  end
  def after_sign_in_path_for(resource)
    chat_rooms_path(resource)
  end
  def after_sign_out_path_for(resource)
    chat_rooms_path
  end

  
  private
    def check_admin
      if "/users".include?(request.path)
        name = "admin"
        passwd = "b51c4e17219231dc715bb26a79f040a411e60bf0"
        authenticate_or_request_with_http_basic('AdminChecker') do |n, p|
          n == name && Digest::SHA1.hexdigest(p) == passwd
        end
      end
    end
>>>>>>> ce17da48ae4473eadd189462a791d92b225e8b9f
end
