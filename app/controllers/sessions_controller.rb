class SessionsController < Devise::SessionsController
  before_action :one_admin_registered?, only: [:new, :create]
  layout "devise"


    protected

  def one_admin_registered?
    redirect_to new_admin_registration_path if Admin.count == 0
  end
end
