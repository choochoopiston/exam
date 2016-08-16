class Users::RegistrationsController < Devise::RegistrationsController

  
    def build_resource(hash=nil)
        hash[:uid] = User.create_unique_string
        super
    end
     
    def update_resource(resource, params)
     if @user.provider == "facebook" || @user.provider == "twitter"
     resource.update_without_current_password(params)
     else
     resource.update_with_password(params)
     end
    end


end
