class ActiveController < ApplicationController
  def index

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
state = value["state"]
start = value["creationtime"]
starttime = a = Time.parse(start)
caller = value["caller"]["number"]
called = value["connected"]["number"]
context = value["dialplan"]["context"]
appname = value["dialplan"]["app_name"]
appdata = value["dialplan"]["app_data"]

duration = (Time.now - starttime).to_i

unless context == "pbxout" && appdata =="(Outgoing Line)"
#puts state, caller, context, appname, called, duration
sipsonline["caller"] = caller
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
end
