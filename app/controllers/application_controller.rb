class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :loadpermissions
  layout :layout_by_resource



  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:firstname, :lastname, :username, :image])
  end


  protected

  def layout_by_resource


    if devise_controller? and controller_path != "devise/registrations"
      "application2"
    elsif controller_path == "queuelog" and action_name == "showcalls"
      "application3"
    elsif controller_path == "monitor" and action_name == "livemonitor"
      "application4"
    else
      "application"
    end
  end


def loadpermissions
@@userpermissions = {
  "permission_accounts" => 0,
  "permission_active" => 0,
  "permission_cdrs" => 0,
  "permission_users" => 0,
  "permission_sips" => 0,
  "permission_extensions" => 0,
  "permission_queues" => 0,
  "permission_agents" => 0,
  "permission_monitor" => 0,
  "permission_routes" => 0,
  "permission_steps" => 0,
  "permission_mohs" => 0,
  "permission_logs" => 0,
  "permission_sounds" => 0,
  "permission_messages" => 0
}
@userpermissionspages=@@userpermissions
if current_user != nil
 userpermissions = JSON.parse(current_user.permission)
 userpermissions.each do |id, value|
 if value == "Yes"
 @userpermissionspages[id]= 1
 else
 @userpermissionspages[id]= 0
 end
end

end

end

end

