class QueuelogController < ApplicationController

def showcalls
@pageid =  params[:pageid]
@queue_id =  params[:queueid]
@exten =  params[:extenid]

@startdate = params[:datestart]
@stopdate = params[:dateend]


session[:qstat_startdate] = @startdate
session[:qstat_stopdate] = @stopdate
session[:qstat_pageid] = @pageid
session[:qstat_queueid] = @queue_id
session[:qstat_exten] = @exten



@queuename = Hotline.find_by(id: @queue_id).name
if @pageid == "123"
@queuecalls = Queuelog.select("time,data2 as data1,(select time from queuelogs b where b.callid=queuelogs.callid order by id desc limit 1) as data2,(select event from queuelogs b where b.callid=queuelogs.callid order by id desc limit 1) as data3,callid").where(['event="ENTERQUEUE" and time >= ? and time < adddate(?,interval 1 day) and queuename =?',@startdate,@stopdate,@queuename])
end

if @pageid == "256"
@queuecalls = Queuelog.select("time,(select b.data2 from queuelogs b where b.callid=queuelogs.callid and event='ENTERQUEUE' order by id asc limit 1) as data1,substring(agent,9) as  data2,(select if(c.event in('COMPLETEAGENT','COMPLETECALLER'),c.data2,if(c.event in('ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER'),c.data4,0))  from queuelogs c where c.callid=queuelogs.callid and event in ('COMPLETEAGENT','COMPLETECALLER','ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER') order by id asc limit 1) as data3,(select event from queuelogs b where b.callid=queuelogs.callid order by id desc limit 1) as data4,callid").where(['event="CONNECT" and time >= ? and time < adddate(?,interval 1 day) and queuename =?',@startdate,@stopdate,@queuename])
end

if @pageid == "342"
@queuecalls = Queuelog.select("time,data2 as data1,(select time from queuelogs c where c.callid=queuelogs.callid order by id desc limit 1) as data2,(select event from queuelogs b where b.callid=queuelogs.callid order by id desc limit 1) as data3").where(['event="ENTERQUEUE" and time >= ? and time < adddate(?,interval 1 day) and queuename =? and callid not in (select callid from queuelogs where event="CONNECT" and time >= ? and time < adddate(?,interval 1 day) and queuename =?)',@startdate,@stopdate,@queuename,@startdate,@stopdate,@queuename])
end


if @pageid == "473"
@queuecalls = Queuelog.select("time,(select time from queuelogs b where b.callid=queuelogs.callid order by id desc limit 1) as data2,event as data3,(select data2 from queuelogs c where c.callid=queuelogs.callid and c.event='ENTERQUEUE' order by id asc limit 1) as data1,callid").where(['event in("CONNECT","RINGNOANSWER") and agent=concat("SIP/",?,?) and time >= ? and time < adddate(?,interval 1 day) and queuename =?',current_user.account.id.to_s,@exten,@startdate,@stopdate,@queuename])
end

if @pageid == "507"
@queuecalls = Queuelog.select("time,(select event from queuelogs b where b.callid=queuelogs.callid order by id desc limit 1) as data3,(select sec_to_time(if(event in('COMPLETEAGENT','COMPLETECALLER'),data2,if(event in('ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER'),data4,0))) from queuelogs d where d.callid=queuelogs.callid order by id desc limit 1) as data2,(select data2 from queuelogs c where c.callid=queuelogs.callid and c.event='ENTERQUEUE' order by id asc limit 1) as data1,callid").where(['event in("CONNECT") and agent=concat("SIP/",?,?) and time >= ? and time < adddate(?,interval 1 day) and queuename =?',current_user.account.id.to_s,@exten,@startdate,@stopdate,@queuename])
end

if @pageid == "683"
@queuecalls = Queuelog.select("time,(select event from queuelogs b where b.callid=queuelogs.callid order by id desc limit 1) as data3,round(data1/1000) as data2,(select data2 from queuelogs c where c.callid=queuelogs.callid and c.event='ENTERQUEUE' order by id asc limit 1) as data1,callid").where(['event in("RINGNOANSWER") and agent=concat("SIP/",?,?) and time >= ? and time < adddate(?,interval 1 day) and queuename =?',current_user.account.id.to_s,@exten,@startdate,@stopdate,@queuename])
end

if @pageid == "7472"
  @queuecalls = Cdr.all.where(accountcode: current_user.account.id).where(['created_at >= ? and created_at < adddate(?,interval 1 day) and src = ? and dcontext = "pbxout"',@startdate,@stopdate,@exten]).order(created_at: :desc)
end

if @pageid == "2573"
  @queuecalls = Cdr.all.where(accountcode: current_user.account.id).where(['created_at >= ? and created_at < adddate(?,interval 1 day) and src = ? and dcontext = "pbxout" and billsec>0',@startdate,@stopdate,@exten]).order(created_at: :desc)
end

if @pageid == "8379"
  @queuecalls = Cdr.all.where(accountcode: current_user.account.id).where(['created_at >= ? and created_at < adddate(?,interval 1 day) and src = ? and dcontext = "pbxout" and billsec=0',@startdate,@stopdate,@exten]).order(created_at: :desc)
end

end

  def index

  @startdate = Date.today.to_s + " 00:00:00"
  @stopdate = Date.today.to_s + " 23:59:59"

@queue_id = Hotline.first.id
@queuename= Hotline.first.name
getstats
@startdate = Date.today
@stopdate = Date.today

@datestart=@startdate.strftime('%Y%m%d')
@dateend=@stopdate.strftime('%Y%m%d')


respond_to do |format|
format.html
format.xlsx{
puts "Excel"
@pageid =  session[:qstat_pageid]
@queue_id =  session[:qstat_queueid]
@exten =  session[:qstat_exten]

@startdate = session[:qstat_startdate]
@stopdate = session[:qstat_stopdate]

@queuename = Hotline.find_by(id: @queue_id).name
if @pageid == "123"
excelpage = "_all"
@queuecalls = Queuelog.select("time,data2 as data1,(select time from queuelogs b where b.callid=queuelogs.callid order by id desc limit 1) as data2,(select event from queuelogs b where b.callid=queuelogs.callid order by id desc limit 1) as data3,callid").where(['event="ENTERQUEUE" and time >= ? and time < adddate(?,interval 1 day) and queuename =?',@startdate,@stopdate,@queuename])
end

if @pageid == "256"
excelpage = "_answered"
@queuecalls = Queuelog.select("time,(select b.data2 from queuelogs b where b.callid=queuelogs.callid and event='ENTERQUEUE' order by id asc limit 1) as data1,substring(agent,9) as  data2,(select if(c.event in('COMPLETEAGENT','COMPLETECALLER'),c.data2,if(c.event in('ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER'),c.data4,0))  from queuelogs c where c.callid=queuelogs.callid and event in ('COMPLETEAGENT','COMPLETECALLER','ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER') order by id asc limit 1) as data3,(select event from queuelogs b where b.callid=queuelogs.callid order by id desc limit 1) as data4,callid").where(['event="CONNECT" and time >= ? and time < adddate(?,interval 1 day) and queuename =?',@startdate,@stopdate,@queuename])
end

if @pageid == "342"
excelpage = "_missed"
@queuecalls = Queuelog.select("time,data2 as data1,(select time from queuelogs c where c.callid=queuelogs.callid order by id desc limit 1) as data2,(select event from queuelogs b where b.callid=queuelogs.callid order by id desc limit 1) as data3").where(['event="ENTERQUEUE" and time >= ? and time < adddate(?,interval 1 day) and queuename =? and callid not in (select callid from queuelogs where event="CONNECT" and time >= ? and time < adddate(?,interval 1 day) and queuename =?)',@startdate,@stopdate,@queuename,@startdate,@stopdate,@queuename])
end


if @pageid == "473"
excelpage = "_all_"+@exten
@queuecalls = Queuelog.select("time,(select time from queuelogs b where b.callid=queuelogs.callid order by id desc limit 1) as data2,event as data3,(select data2 from queuelogs c where c.callid=queuelogs.callid and c.event='ENTERQUEUE' order by id asc limit 1) as data1,callid").where(['event in("CONNECT","RINGNOANSWER") and agent=concat("SIP/",?,?) and time >= ? and time < adddate(?,interval 1 day) and queuename =?',current_user.account.id.to_s,@exten,@startdate,@stopdate,@queuename])
end

if @pageid == "507"
excelpage = "_answered_"+@exten
@queuecalls = Queuelog.select("time,(select event from queuelogs b where b.callid=queuelogs.callid order by id desc limit 1) as data3,(select sec_to_time(if(event in('COMPLETEAGENT','COMPLETECALLER'),data2,if(event in('ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER'),data4,0))) from queuelogs d where d.callid=queuelogs.callid order by id desc limit 1) as data2,(select data2 from queuelogs c where c.callid=queuelogs.callid and c.event='ENTERQUEUE' order by id asc limit 1) as data1,callid").where(['event in("CONNECT") and agent=concat("SIP/",?,?) and time >= ? and time < adddate(?,interval 1 day) and queuename =?',current_user.account.id.to_s,@exten,@startdate,@stopdate,@queuename])
end

if @pageid == "683"
excelpage = "_missed_"+@exten
@queuecalls = Queuelog.select("time,(select event from queuelogs b where b.callid=queuelogs.callid order by id desc limit 1) as data3,round(data1/1000) as data2,(select data2 from queuelogs c where c.callid=queuelogs.callid and c.event='ENTERQUEUE' order by id asc limit 1) as data1,callid").where(['event in("RINGNOANSWER") and agent=concat("SIP/",?,?) and time >= ? and time < adddate(?,interval 1 day) and queuename =?',current_user.account.id.to_s,@exten,@startdate,@stopdate,@queuename])
end

if @pageid == "7472"
excelpage = "_outall_"+@exten
  @queuecalls = Cdr.all.where(accountcode: current_user.account.id).where(['created_at >= ? and created_at < adddate(?,interval 1 day) and src = ? and dcontext = "pbxout"',@startdate,@stopdate,@exten]).order(created_at: :desc)
end

if @pageid == "2573"
excelpage = "_outanswered_"+@exten
  @queuecalls = Cdr.all.where(accountcode: current_user.account.id).where(['created_at >= ? and created_at < adddate(?,interval 1 day) and src = ? and dcontext = "pbxout" and billsec>0',@startdate,@stopdate,@exten]).order(created_at: :desc)
end

if @pageid == "8379"
excelpage = "_outmissed_"+@exten
  @queuecalls = Cdr.all.where(accountcode: current_user.account.id).where(['created_at >= ? and created_at < adddate(?,interval 1 day) and src = ? and dcontext = "pbxout" and billsec=0',@startdate,@stopdate,@exten]).order(created_at: :desc)
end



render :xlsx => "index", :filename => "queue_statistics"+excelpage+".xlsx"
}
end




  end

  def search


  @startdate=params[:startdate] + " 00:00:00"
  @stopdate=params[:stopdate] + " 23:59:59"
  @queue_id=params[:hotline]
  @queuename = Hotline.find_by(id: @queue_id).name


getstats

  @startdate = params[:startdate]
  @stopdate = params[:stopdate]

@datestart=@startdate.to_date.strftime('%Y%m%d')
@dateend=@stopdate.to_date.strftime('%Y%m%d')

puts @datestart
puts @dateend



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

puts "CDR"
@agentdatacdr={}
agentscdrresult = Cdr.group(:src).select("src,count(*) as data1,sum(if(billsec>0,1,0)) as data2,sec_to_time(sum(billsec)) as data3,sec_to_time(sum(billsec) /sum(if(billsec>0,1,0))) as data4").where(['dcontext = "pbxout" and accountcode = ?  and created_at >= ? and created_at < ?',current_user.account.id.to_s,@startdate,@stopdate])
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


puts @agentdatacdr

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

@agentrowdata.push(agentrow)
end


end

puts @agentrowdata

end
