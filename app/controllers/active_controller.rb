class ActiveController < ApplicationController
before_action :authenticate_user!
before_action :getPermissions
before_action :checkPermissions

  def index


uri = URI.parse("http://localhost:8088/ari/bridges")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("sasha", "qscesz")
res = http.request(request)
bridges =  JSON.parse(res.body)

@bridgesonlines = {}
bridges.each do |value|
@bridgesonlines[value["channels"][0]] = 1
@bridgesonlines[value["channels"][1]] = 1
end



uri = URI.parse("http://localhost:8088/ari/channels")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("sasha", "qscesz")
res = http.request(request)
sips =  JSON.parse(res.body)

@siponlines = Array.new
sips.each do |value|
sipsonline={}
#@sipsonline[value["resource"]] = value["state"]
callid = value["id"]
state = value["state"]
name = value["name"]
start = value["creationtime"]
starttime = Time.parse(start)
caller = value["caller"]["number"]
called = value["connected"]["number"]
context = value["dialplan"]["context"]
appname = value["dialplan"]["app_name"]
appdata = value["dialplan"]["app_data"]

duration = (Time.now - starttime).to_i

unless context == "pbxout" && appdata =="(Outgoing Line)"
#puts state, caller, context, appname, called, duration
sipsonline["callid"] = callid
sipsonline["caller"] = caller
sipsonline["name"] = name[4..]
sipsonline["called"] = called
sipsonline["started"] = starttime
sipsonline["duration"] = duration
sipsonline["appname"] = appname
sipsonline["status"] = state
if context == "pbxout"
sipsonline["direction"] = :out
else
sipsonline["direction"] = :in
end

@siponlines.push(sipsonline)
end


#puts @sipsonlines
end


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
unless @userpermissions['permission_active'] == 1
render :file => "#{Rails.root}/public/errors/404.html",  :status => 404
end
end

end
