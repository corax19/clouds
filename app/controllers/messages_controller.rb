class MessagesController < ApplicationController
before_action :authenticate_user!
 before_action :getPermissions
 before_action :checkPermissions


  def index
#puts session[:super_admin_mode]
#puts session[:super_admin_user_id]

  @startdate = Date.today.to_s + " 00:00:00"
  @stopdate = Date.today.to_s + " 23:59:59"

  @event = ""

  @messages = Message.all.where(account_id: current_user.account.id).where(['created_at >= ? and created_at < ?',@startdate,@stopdate]).order(created_at: :desc)
Message.where(account_id: current_user.account.id).where(['`read`=0 and created_at >= ? and created_at < ?',@startdate,@stopdate]).update_all(read: 1)

  @startdate = Date.today
  @stopdate = Date.today


  end


  def search
  @startdate = params[:startdate] + " 00:00:00"
  @stopdate = params[:stopdate] + " 23:59:59"
  @messages = Message.all.where(account_id: current_user.account.id).where(['created_at >= ? and created_at < ?',@startdate,@stopdate]).order(created_at: :desc)
Message.where(account_id: current_user.account.id).where(['`read`=0 and created_at >= ? and created_at < ?',@startdate,@stopdate]).update_all(read: 1)

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
unless @userpermissions['permission_messages'] == 1
render :file => "#{Rails.root}/public/errors/404.html",  :status => 404
end
end


end
