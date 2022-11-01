class MonitorController < ApplicationController
  def index
  end

  def search

  session[:livemonitor_timeout] = params[:timeout]

  session[:livemonitor_active_agents] = params[:active_agents]

  session[:livemonitor_hotline] = params[:hotline]

  session[:livemonitor_startdate] = params[:startdate]
  session[:livemonitor_stopdate] = params[:stopdate]

  session[:livemonitor_starttime] = params[:starttime]
  session[:livemonitor_stoptime] = params[:stoptime]

  redirect_to livemonitor_path
  end

  def livemonitor

@startdate = session[:livemonitor_startdate] + " 00:00:00"
@stopdate = session[:livemonitor_stopdate] + " 23:59:59"
@queuename = Hotline.find_by(id: session[:livemonitor_hotline]).name

puts session[:livemonitor_starttime]
puts session[:livemonitor_stoptime]
@starttime = session[:livemonitor_starttime]
@stoptime = session[:livemonitor_stoptime]

if @starttime.length == 5
@starttime = @starttime + ":" + "00"
end
if @stoptime.length == 5
@stoptime = @stoptime + ":" + "00"
end


   monitorresult = Queuelog.select("sum(if(event='ENTERQUEUE',1,0)) as data1,sum(if(event='CONNECT',1,0)) as data2,sec_to_time(sum(if(event in('COMPLETEAGENT','COMPLETECALLER'),data2,if(event in('ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER'),data4,0)))) as data3,sec_to_time(sum(if(event in('COMPLETEAGENT','COMPLETECALLER'),data2,if(event in('ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER'),data4,0))) /sum(if(event='CONNECT',1,0))) as data4").where(['time >= ? and time < ? and queuename =? and time(time) between ? and ?',@startdate,@stopdate,@queuename,@starttime,@stoptime])

@allcalls = monitorresult[0].data1.to_i
@successcalls = monitorresult[0].data2.to_i
@duration = monitorresult[0].data3.to_s[11,8]
@avgduration = monitorresult[0].data4.to_s[11,8]
@missedcalls = @allcalls - @successcalls


@agentsonline = 0
@agentsoffline = 0
uri = URI.parse("http://localhost:8088/ari/endpoints/SIP")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("sasha", "qscesz")
res = http.request(request)
puts res
sips =  JSON.parse(res.body)
@sipsonline={}
sips.each do |value|
 puts value
 @sipsonline[value["resource"]] = value["state"]
end

@agents = Agent.all.where(account_id: current_user.account.id,hotline: session[:livemonitor_hotline])
@agents.each do |agent|
 exten = Exten.find_by(id: agent.exten_id).exten
 agentexten = current_user.account.id.to_s + exten
 if @sipsonline[agentexten] == nil
  @agentsoffline = @agentsoffline + 1
 elsif @sipsonline[agentexten] == "online"
  puts agentexten
  @agentsonline = @agentsonline + 1
 else
  @agentsoffline = @agentsoffline + 1
 end
end


uri = URI.parse("http://localhost:8088/ari/channels")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("sasha", "qscesz")
res = http.request(request)
sips =  JSON.parse(res.body)

@callsonline = 0
@callswaiting = 0
callids=Array.new
agentsonline={}
@siponlines = Array.new
sips.each do |value|
sipsonline={}
#@sipsonline[value["resource"]] = value["state"]
puts value
callid = value["id"]
state = value["state"]
start = value["creationtime"]
exten = value["accountcode"]
starttime = Time.parse(start)
caller = value["caller"]["number"]
called = value["connected"]["number"]
context = value["dialplan"]["context"]
appname = value["dialplan"]["app_name"]
appdata = value["dialplan"]["app_data"]

duration = (Time.now - starttime).to_i

agentsonline[exten]={state: state,number: called, duration: duration}

puts context
puts appname
if context == "macro-queue" && appname =="Queue"
puts appdata
if appdata[0..@queuename.length-1] == @queuename
puts "My Queue"
puts callid
callids.push(callid)

isconnected = Queuelog.where(['callid= ? and event="CONNECT"',callid]).count
if isconnected > 0
@callsonline = @callsonline + 1
else
@callswaiting = @callswaiting + 1
end

end
@siponlines.push(sipsonline)
end

puts callids
puts @sipsonlines
end



onepc = (@allcalls.to_f / 100).to_f
if @allcalls >0
@sla = (@successcalls.to_i / onepc).to_f.round(2)
end

agentsresult = Queuelog.group(:agent).select("agent,sum(if(event='RINGNOANSWER',1,0)) as data1,sum(if(event='CONNECT',1,0)) as data2,sec_to_time(sum(if(event in('COMPLETEAGENT','COMPLETECALLER'),data2,if(event in('ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER'),data4,0)))) as data3,sec_to_time(sum(if(event in('COMPLETEAGENT','COMPLETECALLER'),data2,if(event in('ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER'),data4,0))) /sum(if(event ='CONNECT',1,0))) as data4").where(['time >= ? and time < ? and queuename =? and time(time) between ? and ?',@startdate,@stopdate,@queuename,@starttime,@stoptime])


@agentdata={}
agentsresult.each do |agent|
if agent["agent"] != "NONE"
agentrow={}
agentexten=Exten.where(account_id: current_user.account.id).where(exten: agent.agent[8..10]).first
agentid= agentexten.exten
agentrow["agentname"] = agentexten.name
agentrow["agent"] = agent.agent[8..10]
agentrow["success"] = agent.data2
agentrow["missed"] = agent.data1
agentrow["duration"] = agent.data3.to_s[11,8]
agentrow["avgduration"] = agent.data4.to_s[11,8]
@agentdata[agentid]=agentrow
end
end

puts "CDR"
@agentdatacdr={}
agentscdrresult = Cdr.group(:src).select("src,count(*) as data1,sum(if(billsec>0,1,0)) as data2,sec_to_time(sum(billsec)) as data3,sec_to_time(sum(billsec) /sum(if(billsec>0,1,0))) as data4").where(['dcontext = "pbxout" and accountcode = ?  and created_at >= ? and created_at < ? and time(created_at) between ? and ?',current_user.account.id.to_s,@startdate,@stopdate,@starttime,@stoptime])
agentscdrresult.each do |agentcdr|
agentrow={}
agentid= agentcdr.src
agentrow["cdrall"] = agentcdr.data1
agentrow["cdrsuccess"] = agentcdr.data2
agentrow["cdrmissed"] = agentcdr.data1.to_i - agentcdr.data2.to_i
agentrow["cdrduration"] = agentcdr.data3.to_s[11,8]
agentrow["cdravgduration"] = agentcdr.data4.to_s[11,8]
@agentdatacdr[agentid]=agentrow
end


@allagents=Agent.where(hotline_id: session[:livemonitor_hotline]).all
@agentrowdata=Array.new
@allagents.each do |agent|
agentrow={}
agentnum = Exten.find_by(id: agent.exten_id).exten
agentrow["agent"] = agentnum
if @agentdata[agentnum] == nil
agentrow["agentname"] = ""
agentrow["success"] = 0
agentrow["misssed"] = 0
agentrow["all"] = 0
agentrow["duration"] = "00:00:00"
agentrow["avgduration"] = "00:00:00"

else
agentrow["agentname"] = @agentdata[agentnum]["agentname"]
agentrow["success"] = @agentdata[agentnum]["success"]
agentrow["missed"] = @agentdata[agentnum]["missed"]
agentrow["all"] = @agentdata[agentnum]["missed"].to_i + @agentdata[agentnum]["success"].to_i
agentrow["duration"] = @agentdata[agentnum]["duration"]
agentrow["avgduration"] = @agentdata[agentnum]["avgduration"]
end
puts agentnum
if @agentdatacdr[agentnum] == nil
agentrow["cdrsuccess"] = 0
agentrow["cdrmisssed"] = 0
agentrow["cdrall"] = 0
agentrow["cdrduration"] = "00:00:00"
agentrow["cdravgduration"] = "00:00:00"

else
agentrow["cdrsuccess"] = @agentdatacdr[agentnum]["cdrsuccess"]
agentrow["cdrmissed"] = @agentdatacdr[agentnum]["cdrmissed"]
agentrow["cdrall"] = @agentdatacdr[agentnum]["cdrall"]
agentrow["cdrduration"] = @agentdatacdr[agentnum]["cdrduration"]
agentrow["cdravgduration"] = @agentdatacdr[agentnum]["cdravgduration"]
end

#puts agentsonline
agentnumfull = current_user.account.id.to_s + agentnum
agentrow[:state] = @sipsonline[agentnumfull]
if agentrow[:state] == "unknown"
agentrow[:state] = "offline"
end
unless  agentsonline[agentnumfull] == nil
agentstatedata = agentsonline[agentnumfull]
agentrow[:state] = agentstatedata[:state]
agentrow[:number] = agentstatedata[:number]
agentrow[:duration] = agentstatedata[:duration]
end

if session[:livemonitor_active_agents] == "No" || agentrow[:state] != "offline"
@agentrowdata.push(agentrow)
end

end

@callerres = Queuelog.select("time,data2,(select agent from queuelogs b where b.id>queuelogs.id and b.callid=queuelogs.callid  and b.event='CONNECT' order by b.id asc limit 1) as myagent,(select timediff(now(),time) from queuelogs c where c.id>queuelogs.id and c.callid=queuelogs.callid and c.event='CONNECT' order by c.id asc limit 1) as mytime,timediff(now(),time) as fulltime").where(['event="ENTERQUEUE" and callid in (?)',callids]).order(:id)
#puts callerres
@callerres.each do |callerrow|
puts callerrow["time"]
puts callerrow["data2"]
puts callerrow["myagent"]
if  callerrow["myagent"] == nil
callerrow["myagent"] = ""
else
callerrow["myagent"] = callerrow["myagent"][8..10]
end

if  callerrow["mytime"]  == nil
callerrow["mytime"] = callerrow["fulltime"].to_s[11..19]
else
callerrow["mytime"] = callerrow["mytime"].to_s[11..19]
end


puts callerrow["mytime"]
end

#puts @agentrowdata

end

end
