class Api::ClientsController < ApplicationController
before_action :check_token
skip_before_action :verify_authenticity_token

def index
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    clients = Client.all.where(account_id: account.id).select("id, firstname, lastname, phone1, phone2, phone3, idnum, country, city, address, email, birthday, created_at, updated_at, blacklist")
    render json: clients
end


  def destroy
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    client = Client.where(account_id: account.id).find_by(id: params[:id])
    if client == nil
    render plain: "Client Not Found"
    else
    client.destroy
    Log.create(account: account, user: User.where('account_id = ? and isadmin>=0',account.id).first, event: "apidestroyclient", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    render plain: "Client was successfully destroyed."
    end
  end


  def update
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    client = Client.where(account_id: account.id).find_by(id: params[:id])
    if client == nil
    render plain: "Client Not Found"
    else
    client.firstname = params[:firstname] if params[:firstname] != nil
    client.lastname = params[:lastname] if params[:lastname] != nil
    client.phone1 = params[:phone1] if params[:phone1] != nil
    client.phone2 = params[:phone2] if params[:phone2] != nil
    client.phone3 = params[:phone3] if params[:phone3] != nil
    client.idnum = params[:idnum] if params[:idnum] != nil
    client.country = params[:country] if params[:country] != nil
    client.city = params[:city] if params[:city] != nil
    client.address = params[:address] if params[:address] != nil
    client.email = params[:email] if params[:email] != nil
    client.birthday = params[:birthday] if params[:birthday] != nil
    client.blacklist = params[:blacklist] if params[:blacklist] != nil

    client.save
    Log.create(account: account, user: User.where('account_id = ? and isadmin>=0',account.id).first, event: "apiupdateclient", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    render plain: "Client was successfully updated."
    end
  end

  def create
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    client = Client.new

    client.account_id = account.id
    client.firstname = params[:firstname] if params[:firstname] != nil
    client.lastname = params[:lastname] if params[:lastname] != nil
    client.phone1 = params[:phone1] if params[:phone1] != nil
    client.phone2 = params[:phone2] if params[:phone2] != nil
    client.phone3 = params[:phone3] if params[:phone3] != nil
    client.idnum = params[:idnum] if params[:idnum] != nil
    client.country = params[:country] if params[:country] != nil
    client.city = params[:city] if params[:city] != nil
    client.address = params[:address] if params[:address] != nil
    client.email = params[:email] if params[:email] != nil
    client.birthday = params[:birthday] if params[:birthday] != nil
    client.blacklist = params[:blacklist] if params[:blacklist] != nil

    client.save
    Log.create(account: account, user: User.where('account_id = ? and isadmin>=0',account.id).first, event: "apicreateclient", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    render plain: "Client was successfully created."
  end


def check_token
    if request.headers['Authorization'] == nil
    render plain: "Invalid token"
    else
    token = request.headers['Authorization'].split(' ').last
    if token == nil
    render plain: "Invalid token"
    else
    if token == nil
    render plain: "Account Not Found"
    else
    account = Account.find_by(token: token)
    if account == nil
    render plain: "Account Not Found"
    else
    unless account.apiips.split(/\r\n/).include? request.remote_ip
    render plain: "Your IP isn't allowed for this API"
    end
    end
    end
    end
    end
end

    def client_params
      params.require(:client).permit(:firstname, :lastname, :phone1, :phone2, :phone3, :idnum, :country, :city, :address, :email, :birthday, :blacklist)
    end

end