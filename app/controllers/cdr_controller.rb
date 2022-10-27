class CdrController < ApplicationController
before_action :authenticate_user!
 before_action :getPermissions
 before_action :checkPermissions

  def index

  @startdate = Date.today.to_s + " 00:00:00"
  @stopdate = Date.today.to_s + " 23:59:59"

  @caller = ""
  @called = ""
  @direction = ""

  @cdrs = Cdr.all.where(accountcode: current_user.account.id).where(['created_at >= ? and created_at < ?',@startdate,@stopdate]).order(created_at: :desc)

#  @cdrs = Cdr.all.where(accountcode: current_user.account.id).where(['created_at >= ? and created_at < ?',@startdate,@stopdate])

  @startdate = Date.today
  @stopdate = Date.today


  end


  def search
  @startdate=params[:startdate] + " 00:00:00"
  @stopdate=params[:stopdate] + " 23:59:59"
  @caller=params[:caller]
  @called=params[:called]
  @direction=params[:direction]

  @cdrs = Cdr.all.where(accountcode: current_user.account.id).where(['created_at >= ? and created_at < ? and src like if(?="","%",concat("%",?,"%"))  and dst like if(?="","%",concat("%",?,"%")) and dcontext like if(?="" or ? = "Both","%",if(?="Inbound","pbxin","pbxout"))',@startdate,@stopdate,@caller,@caller,@called,@called,@direction,@direction,@direction]).order(created_at: :desc)

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
unless @userpermissions['permission_agents'] == 1
render :file => "#{Rails.root}/public/errors/404.html",  :status => 404
end
end

end
