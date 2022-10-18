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
@users = User.where(account_id: current_user.account.id)
end


def new

@user = User.new
end

def create
 @user = User.new(user_params)
 @user.account = current_user.account
 if @user.save
  redirect_to users_path
 else
  render :new, status: :unprocessable_entity
 end
end


def edit
 @userpermissions=@@userpermissions
 @select_list = [ 'Yes', 'No' ]
 @user = User.find(params[:id])
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
  flash[:notice] = 'User has been updated'
  redirect_to users_path
 else
  render :edit, status: :unprocessable_entity
 end

 else
 if @user.update(user_params2)
  bypass_sign_in(@user)
  flash[:notice] = 'User has been updated'
  redirect_to users_path
 else
  render :edit, status: :unprocessable_entity
 end

end
end




def destroy
@user = User.find(params[:id])
@user.destroy
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

end
