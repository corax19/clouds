class SoundsController < ApplicationController
before_action :authenticate_user!
 before_action :getPermissions
 before_action :checkPermissions

  def index
@sounds = Sound.where(account_id: current_user.account.id)
  end

  def new
@sound = Sound.new
  end

  def create

 @sound = Sound.new(sound_params)
 @sound.account = current_user.account
 if @sound.save
  Log.create(account: current_user.account, user: current_user, event: "createsound", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
  redirect_to sounds_path
 else
flash[:alert] = 'Sound not added'
  render :new, status: :unprocessable_entity
 end


  end

  def destroy

@sound = Sound.find(params[:id])
@sound.destroy
Log.create(account: current_user.account, user: current_user, event: "destroysound", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)

redirect_to sounds_path


  end


private
def sound_params
 params.require(:sound).permit(:name, :audio)
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
unless @userpermissions['permission_sounds'] == 1
render :file => "#{Rails.root}/public/errors/404.html",  :status => 404
end
end

end
