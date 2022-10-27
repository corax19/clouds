class QueuelogController < ApplicationController

  def index

  @startdate = Date.today.to_s + " 00:00:00"
  @stopdate = Date.today.to_s + " 23:59:59"

@queue_id = Hotline.first.id
@queuename= Hotline.first.name
getstats
@startdate = Date.today
 @stopdate = Date.today


  end

  def search


  @startdate=params[:startdate] + " 00:00:00"
  @stopdate=params[:stopdate] + " 23:59:59"
  @queue_id=params[:hotline]
  @queuename = Hotline.find_by(id: @queue_id).name


getstats

  @startdate = params[:startdate]
  @stopdate = params[:stopdate]




  end


private
def getstats

logresult = Queuelog.select("sum(if(event='ENTERQUEUE',1,0)) as data1,sum(if(event='CONNECT',1,0)) as data2,sec_to_time(sum(if(event in('COMPLETEAGENT','COMPLETECALLER'),data2,if(event in('ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER'),data4,0)))) as data3,sec_to_time(sum(if(event in('COMPLETEAGENT','COMPLETECALLER'),data2,if(event in('ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER'),data4,0))) /sum(if(event='CONNECT',1,0))) as data4").where(['time >= ? and time < ? and queuename =?',@startdate,@stopdate,@queuename])
#.count@successcalls = Queuelog.all.where(['event= "CONNECT" and time >= ? and time < ? and queuename =?',@startdate,@stopdate,@queuename]).count
@allcalls = logresult[0].data1.to_i
@successcalls = logresult[0].data2.to_i
@duration = logresult[0].data3.to_s[11,8]
@avgduration = logresult[0].data4.to_s[11,8]
#.to_d.strftime('%H:%M:%S')
@missedcalls = @allcalls - @successcalls

agentsresult = Queuelog.group(:agent).select("agent,sum(if(event='RINGNOANSWER',1,0)) as data1,sum(if(event='CONNECT',1,0)) as data2,sec_to_time(sum(if(event in('COMPLETEAGENT','COMPLETECALLER'),data2,if(event in('ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER'),data4,0)))) as data3,sec_to_time(sum(if(event in('COMPLETEAGENT','COMPLETECALLER'),data2,if(event in('ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER'),data4,0))) /sum(if(event ='CONNECT',1,0))) as data4").where(['time >= ? and time < ? and queuename =?',@startdate,@stopdate,@queuename])


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

puts @agentdata

@allagents=Agent.where(hotline_id: @queue_id).all
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
@agentrowdata.push(agentrow)
end


end

end
