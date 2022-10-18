class SoundsController < ApplicationController
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
puts @sound.id
  redirect_to sounds_path
 else
  render :new, status: :unprocessable_entity
 end


  end

  def destroy

@sound = Sound.find(params[:id])
@sound.destroy
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
