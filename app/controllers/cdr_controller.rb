class CdrController < ApplicationController
before_action :authenticate_user!
 before_action :getPermissions
 before_action :checkPermissions

  def index
  end


  def search
  @startdate=params[:startdate]
  @stopdate=params[:stopdate]
  @caller=params[:caller]
  @called=params[:called]
  @direction=params[:direction]
  end







def getPermissions
@userpermissions=@@userpermissions
userpermissions = JSON.parse(current_user.permission)
userpermissions.each do |id, value|
if value == "Yes"
@userpermissions[id]= 1
else
@userpermissions[id]= 0
end
end
end


def checkPermissions
unless @userpermissions['permission_agents'] == 1
render :file => "#{Rails.root}/public/errors/404.html",  :status => 404
end
end

end
