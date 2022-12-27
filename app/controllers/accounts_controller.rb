class AccountsController < ApplicationController
before_action :authenticate_user!
 before_action :getPermissions
 before_action :checkPermissions
 before_action :set_account, only: %i[ destroy edit update enter]

def index
@accounts = Account.all
end


def new
    @account =  Account.new
end

def gettoken
newtoken = SecureRandom.hex + SecureRandom.hex
render plain: newtoken
end


def create
@account = Account.new(account_params)
    respond_to do |format|
      if @account.save
puts "Creating user"


allpermissions = {
  "permission_accounts" => "Yes",
  "permission_users" => "Yes",
  "permission_sips" => "Yes",
  "permission_extensions" => "Yes",
  "permission_queues" => "Yes",
  "permission_agents" => "Yes",
  "permission_routes" => "Yes",
  "permission_steps" => "Yes",
  "permission_mohs" => "Yes",
  "permission_logs" => "Yes",
  "permission_sounds" => "Yes",
  "permission_messages" => "Yes"
}

userpermissions=Array.new
allpermissions.each do |id, value|
userpermissions.push([id, value])
end



useremail =  @account.id.to_s+"@email.com"
username =  "admin"+@account.id.to_s
puts useremail
puts username
puts @account.id.to_s
user1 = User.create(email: useremail.to_s,username: username, firstname: "My First name", lastname: "My Last name")
user1.account_id = @account.id
user1.password = "password"+@account.id.to_s+"PBX"
user1.permission = userpermissions.to_json
user1.save
puts "End Creating user"
        Log.create(account: current_user.account, user: current_user, event: "createaccount", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to accounts_path, notice: "Account was successfully created." }
        format.json { render :show, status: :created, location: @exten }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @exten.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @account.destroy
        Log.create(account: current_user.account, user: current_user, event: "destroyaccount", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def edit
  end


  def enter
   bypass_sign_in(@account.users.first)
session[:super_admin_mode] = true
session[:super_admin_user_id] = current_user.id.to_s
  redirect_to messages_path
  end

  def entersuperuser
  session[:super_admin_mode] = false
   bypass_sign_in(User.find_by(id: session[:super_admin_user_id]))
  redirect_to messages_path
  end



def show
@account = Account.find_by(id: current_user.account.id)
end


  def updatemyaccount
 @myaccount = current_user.account
    respond_to do |format|
      if @myaccount.update(myaccount_params)
        Log.create(account: current_user.account, user: current_user, event: "updatemyaccount", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to myaccount_path, notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @myaccount }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @myaccount.errors, status: :unprocessable_entity }
      end
    end
  end




  def update
    respond_to do |format|
      if @account.update(account_params)
        Log.create(account: current_user.account, user: current_user, event: "updateaccount", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to accounts_path, notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @sip }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sip.errors, status: :unprocessable_entity }
      end
    end
  end





  private
    # Only allow a list of trusted parameters through.
    def myaccount_params
      params.require(:account).permit(:name, :phone, :address, :image, :token, :apiips)
    end


    def account_params
      params.require(:account).permit(:name, :phone, :address, :image, :sipips, :webips)
    end


    def set_account
      @account = Account.find(params[:id])
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
if action_name != "entersuperuser"
unless @userpermissions['permission_accounts'] == 1
render :file => "#{Rails.root}/public/errors/404.html",  :status => 404
end
end
end

end
