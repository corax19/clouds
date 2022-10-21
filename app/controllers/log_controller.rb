class LogController < ApplicationController
before_action :authenticate_user!
 before_action :getPermissions
 before_action :checkPermissions


  def index
  @startdate = Date.today.to_s + " 00:00:00"
  @stopdate = Date.today.to_s + " 23:59:59"

  @event = ""

  @logs = Log.all.where(account_id: current_user.account.id).where(['created_at >= ? and created_at < ?',@startdate,@stopdate])

  @startdate = Date.today
  @stopdate = Date.today



  end


  def search
  @startdate = params[:startdate] + " 00:00:00"
  @stopdate = params[:stopdate] + " 23:59:59"
  @event = params[:event]
  if @event == "" || @event == "All"
  @logs = Log.all.where(account_id: current_user.account.id).where(['created_at >= ? and created_at < ?',@startdate,@stopdate])
  else
  @logs = Log.all.where(account_id: current_user.account.id).where(['created_at >= ? and created_at < ? and event= ?',@startdate,@stopdate,@event])
  end

  @startdate = params[:startdate]
  @stopdate = params[:stopdate]


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
unless @userpermissions['permission_logs'] == 1
render :file => "#{Rails.root}/public/errors/404.html",  :status => 404
end
end


end
