class CdrController < ApplicationController
before_action :authenticate_user!
 before_action :getPermissions
 before_action :checkPermissions

def index
#puts Rails.configuration.isinhouse
if request.format == "text/html"
if params[:page] == nil
puts "Lets begin"
session[:cdr_startdate] = nil
session[:cdr_stopdate] = nil
session[:cdr_caller] = nil
session[:cdr_called] = nil
session[:cdr_direction] = nil

end
end

  @startdate = Date.today.to_s + " 00:00:00"
  @stopdate = Date.today.to_s + " 23:59:59"

  @caller = ""
  @called = ""
  @direction = ""
if session[:cdr_startdate] != nil
puts "CDR"
puts session[:cdr_startdate]
    @startdate = session[:cdr_startdate] + " 00:00:00"
    @stopdate = session[:cdr_stopdate] + " 23:59:59"
    @caller = session[:cdr_caller]
    @called = session[:cdr_called]
    @direction = session[:cdr_direction]
end
session[:cdr_startdate] = @startdate
session[:cdr_stopdate] = @stopdate
session[:cdr_caller] = @caller
session[:cdr_called] = @called
session[:cdr_direction] = @direction

  @pagy, @cdrs = pagy( Cdr.all.where(accountcode: current_user.account.id).where(['created_at >= ? and created_at < ?',@startdate,@stopdate]).order(created_at: :desc), page: params[:page], items: 25)



  respond_to do |format|
    format.html
    format.xlsx{
    puts "Excel"
puts session[:cdr_startdate]
    @startdate = session[:cdr_startdate] + " 00:00:00"
    @stopdate = session[:cdr_stopdate] + " 23:59:59"
    @caller = session[:cdr_caller]
    @called = session[:cdr_called]
    @direction = session[:cdr_direction]
    @cdrsexport = Cdr.all.where(accountcode: current_user.account.id).where(['created_at >= ? and created_at < ? and src like if(?="","%",concat("%",?,"%"))  and dst like if(?="","%",concat("%",?,"%")) and dcontext like if(?="" or ? = "Both","%",if(?="Inbound","pbxin","pbxout"))',@startdate,@stopdate,@caller,@caller,@called,@called,@direction,@direction,@direction]).order(created_at: :desc)
    render :xlsx => "index", :filename => "cdr.xlsx"
    }
if session[:cdr_startdate] != nil
@startdate = session[:cdr_startdate].to_date
@stopdate = session[:cdr_stopdate].to_date
#@startdate = Date.today
#@stopdate = Date.today

else
@startdate = Date.today
@stopdate = Date.today
end


  end
end


  def search
  @startdate=params[:startdate] + " 00:00:00"
  @stopdate=params[:stopdate] + " 23:59:59"
  @caller=params[:caller]
  @called=params[:called]
  @direction=params[:direction]

  @pagy, @cdrs = pagy(Cdr.all.where(accountcode: current_user.account.id).where(['created_at >= ? and created_at < ? and src like if(?="","%",concat("%",?,"%"))  and dst like if(?="","%",concat("%",?,"%")) and dcontext like if(?="" or ? = "Both","%",if(?="Inbound","pbxin","pbxout"))',@startdate,@stopdate,@caller,@caller,@called,@called,@direction,@direction,@direction]).order(created_at: :desc), page: params[:page], items: 25)

  @startdate = params[:startdate]
  @stopdate = params[:stopdate]


session[:cdr_startdate] = @startdate
session[:cdr_stopdate] = @stopdate
session[:cdr_caller] = @caller
session[:cdr_called] = @called
session[:cdr_direction] = @direction

puts session[:cdr_startdate]
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
unless @userpermissions['permission_agents'] == 1
render :file => "#{Rails.root}/public/errors/404.html",  :status => 404
end
end

end
