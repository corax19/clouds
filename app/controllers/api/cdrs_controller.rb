class Api::CdrsController < ApplicationController
before_action :check_token
skip_before_action :verify_authenticity_token

def index
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    startdate = params[:startdate] + ' 00:00:00'
    stopdate = params[:stopdate] + ' 23:59:59'
    cdrs = Cdr.all.where('accountcode = ? and start between ? and ?',account.id,startdate,stopdate).select("id, start, src, dst, if(dcontext = 'pbxin','Inbound',if(dcontext='pbxout','Outbound','')) as direction,billsec, disposition, uniqueid")
    render json: cdrs
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