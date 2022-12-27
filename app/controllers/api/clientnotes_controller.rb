class Api::ClientnotesController < ApplicationController
before_action :check_token
skip_before_action :verify_authenticity_token

def index
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    notes = Note.all.where(client_id: params[:clientid])
    render json: notes
end


  def destroy
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    note = Note.find_by(id: params[:id])
    if note == nil
    render plain: "Note Not Found"
    else
    note.destroy
    Log.create(account: account, user: User.where('account_id = ? and isadmin>=0',account.id).first, event: "apidestroynote", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    render plain: "Note was successfully destroyed."
    end
  end


  def create
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    note = Note.new
    note.client_id = params[:clientid]
    note.user_id = User.where('account_id = ? and isadmin>=0',account.id).first.id
    note.subject = params[:subject] if params[:subject] != nil
    note.body = params[:body] if params[:body] != nil
    note.callid = params[:callid] if params[:callid] != nil
    note.save
    Log.create(account: account, user: User.where('account_id = ? and isadmin>=0',account.id).first, event: "apicreateclientnote", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    render plain: "Client was successfully updated."
  end


  def update
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    client = Client.where(account_id: account.id).find_by(id: params[:id])
    note = Note.find_by(id: params[:id])
    if note == nil
    render plain: "Note Not Found"
    else
    note.subject = params[:subject] if params[:subject] != nil
    note.body = params[:body] if params[:body] != nil
    note.callid = params[:callid] if params[:callid] != nil
    note.save
    Log.create(account: account, user: User.where('account_id = ? and isadmin>=0',account.id).first, event: "apiupdateclientnote", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    render plain: "Client was successfully updated."
    end
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
    else
    client = Client.where(account_id: account.id).find_by(id: params[:clientid])
    if client == nil
    render plain: "Client Not Found"
    end
    end
    end
    end
    end
    end
end


end