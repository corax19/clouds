class Api::QueueagentsController < ApplicationController
before_action :check_token
skip_before_action :verify_authenticity_token

def index
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    agents = Agent.all.where('name like   ?',account.id.to_s+"%").select("id, substring(name,6) as name,substring(interface,9) as ext, penalty, paused, created_at")
    render json: agents
end


  def create
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    agent = Agent.new
    agent.account_id = account.id
    agent.hotline_id = Hotline.where(account_id: account.id).find_by(id: params[:queueid]).id
    agent.name = Hotline.find_by(id: params[:queueid]).name
    agent.penalty = params[:penalty]
    agent.paused = 0
    agent.queue_name = Hotline.find_by(id: params[:queueid]).name
    agent.exten_id =  Exten.find_by(exten: params[:ext]).id
    if Rails.configuration.isinhouse == "Yes"
     agent.interface = "SIP/" +  Exten.find_by(exten: params[:ext]).exten
     agent.membername = "SIP/" + Exten.find_by(exten: params[:ext]).exten
    else
     agent.interface = "SIP/" + account.id.to_s + Exten.find_by(exten: params[:ext]).exten
     agent.membername = "SIP/" + account.id.to_s + Exten.find_by(exten: params[:ext]).exten
    end
    agent.save
    agent.uniqueid = agent.id
    agent.save
    Log.create(account: account, user: User.where('account_id = ? and isadmin>=0',account.id).first, event: "apicreatequeueagent", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    render plain: "Queue Agent was successfully created."
  end


  def destroy
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    agent = Agent.where(account_id: account.id).find_by(id: params[:id])
    if agent == nil
    render plain: "Agent Not Found"
    else
    agent.destroy
    Log.create(account: account, user: User.where('account_id = ? and isadmin>=0',account.id).first, event: "apidestroyqueueagent", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    render plain: "Queue Agent was successfully destroyed."
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
    queue = Hotline.where(account_id: account.id).find_by(id: params[:queueid])
    if queue == nil
    render plain: "Queue Not Found"
    end
    end
    end
    end
    end
    end
end

end