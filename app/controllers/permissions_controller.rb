class PermissionsController < ApplicationController

before_action :authenticate_user!
before_action :getPermissions
before_action :checkPermissions



def index
#myarr = Array({:a => "a1", :b => "b2"})
#mystr  = JSON.encode(myarr)
#puts mystr
#mystr = myarr.to_json
#puts mystr
#puts @@userpermissions["sounds"]
puts "get users"
@users = User.where('account_id = ? and isadmin>=0',current_user.account.id)
puts "got users"
end


def new

@user = User.new
end

def create
 @user = User.new(user_params)
 @user.account = current_user.account

allpermissions = {
  "permission_accounts" => "No",
  "permission_cdrs" => "No",
  "permission_active" => "No",
  "permission_users" => "No",
  "permission_sips" => "No",
  "permission_extensions" => "No",
  "permission_queues" => "No",
  "permission_agents" => "No",
  "permission_monitor" => "No",
  "permission_categories" => "No",
  "permission_routes" => "No",
  "permission_steps" => "No",
  "permission_mohs" => "No",
  "permission_logs" => "No",
  "permission_sounds" => "No",
  "permission_clients" => "No",
  "permission_messages" => "No"
}

userpermissions=Array.new
allpermissions.each do |id, value|
 userpermissions.push([id, value])
end

@user.permission = userpermissions.to_json
respond_to do |format|
 if @user.save
    Log.create(account: current_user.account, user: current_user, event: "createuser", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
  redirect_to users_path
 else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }

#  render :new, status: :unprocessable_entity
 end
end

end


def edit
 @user = User.find(params[:id])
setuserpermissions
end

def show
end


def update
@user = User.find(params[:id])
@user.permission="123"

userpermissions=Array.new
params[:user].each do |id, value|
if id[0,11] == "permission_"
userpermissions.push([id, value])
end
end

@user.permission = userpermissions.to_json

if(params.require(:user)[:password].blank?)

 if @user.update(user_params_update)
  Log.create(account: current_user.account, user: current_user, event: "updateuser", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
  flash[:notice] = 'User has been updated'
  redirect_to users_path
 else
  setuserpermissions
  flash[:alert] = 'User not updated'
  render :edit, status: :unprocessable_entity
 end

 else

 if @user.update(user_params2)
    Log.create(account: current_user.account, user: current_user, event: "updateuser", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    if @user == current_user
      bypass_sign_in(@user)
    end
  flash[:notice] = 'User has been updated'
  redirect_to users_path
 else
#  render :edit, status: :unprocessable_entity
  setuserpermissions
  flash[:alert] = 'User not updated'
  render :edit, status: :unprocessable_entity
 end

end
end




def destroy
@user = User.find(params[:id])
@user.destroy
    Log.create(account: current_user.account, user: current_user, event: "destroyuser", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
redirect_to users_path
end


private
def user_params
puts "Updating WITH Password"
 params.require(:user).permit(:username, :username, :email, :firstname, :lastname, :password, :image)
end

def user_params2
puts "Updating WITH Password"
 params.require(:user).permit(:permission, :username, :username, :email, :firstname, :lastname, :password, :image)
end

def user_params_update
puts "Updating WITHOUT Password"
 params.require(:user).permit(:permission,:username, :email, :firstname, :lastname, :image)
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
unless @userpermissions['permission_users'] == 1
render :file => "#{Rails.root}/public/errors/404.html",  :status => 404
end
end

def setuserpermissions
@select_list = [ 'Yes', 'No' ]
allpermissions = {
  "permission_accounts" => "No",
  "permission_cdrs" => "No",
  "permission_active" => "No",
  "permission_users" => "No",
  "permission_sips" => "No",
  "permission_extensions" => "No",
  "permission_queues" => "No",
  "permission_agents" => "No",
  "permission_monitor" => "No",
  "permission_categories" => "No",
  "permission_routes" => "No",
  "permission_steps" => "No",
  "permission_mohs" => "No",
  "permission_logs" => "No",
  "permission_sounds" => "No",
  "permission_clients" => "No",
  "permission_messages" => "No"
}
@edituserpermission = allpermissions
if @user.permission != nil
edituserpermissions = JSON.parse(@user.permission)
#edituserpermissions = allpermissions
edituserpermissions.each do |id, value|
if value == "Yes"
@edituserpermission[id]= 1
else
@edituserpermission[id]= 0
end
end

end

end

end
