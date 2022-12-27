class Api::QueuelogsController < ApplicationController
before_action :check_token
skip_before_action :verify_authenticity_token

def index
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    startdate = params[:startdate] + ' 00:00:00'
    stopdate = params[:stopdate] + ' 23:59:59'
    queuename = account.id.to_s + '_' + params[:queuename]
    queuelogs = Queuelog.all.where('queuename = ? and time between ? and ?',queuename,startdate,stopdate)
    render json: queuelogs
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

end