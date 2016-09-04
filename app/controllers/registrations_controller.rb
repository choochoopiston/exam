class RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    redirect_to new_user_session_path
  end

  def after_inactive_sign_up_path_for(resource)
    redirect_to new_user_session_path
  end
end