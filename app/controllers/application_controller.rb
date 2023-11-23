class ApplicationController < ActionController::Base
   before_action :devise_permitted_parameters, if: :devise_controller?
   before_action :authenticate_user!, except: [:new]
  private 

    def devise_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:base,:base_sub,:team,:position, :position_sub,:group])
    end  
end
