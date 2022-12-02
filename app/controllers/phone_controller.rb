class PhoneController < ApplicationController
before_action :authenticate_user!
  def show
  @client = Client.new
#find_by(id: 2)
  end



  def getinfo
puts params[:callerid]
  @client = Client.where('account_id=? and (phone1 = ? or phone2 = ? or phone3 = ?)',current_user.account.id.to_s, params[:callerid], params[:callerid], params[:callerid]).first
  if @client == nil
    @client = Client.new
    @client.phone1 = params[:callerid]
  end
  end

  def getnotes
puts params[:direction]
    if params[:direction] == "IN"
    callnumber  = params[:callerid]
    else
    callnumber  = current_user.username[4..]
    end
puts current_user.username
puts "CALLID number"
puts callnumber

    @callid = ""
    uri = URI.parse("http://localhost:8088/ari/channels")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth("sasha", "qscesz")
    res = http.request(request)
    sips =  JSON.parse(res.body)
    @siponlines = Array.new
    sips.each do |value|
        callid = value["id"]
        caller = value["caller"]["number"]
        if caller == callnumber
            @callid = callid
puts caller + " "+ callid  + " "+ callnumber+ " "+ @callid

        end
    end
    @client = Client.where('account_id=? and (phone1 = ? or phone2 = ? or phone3 = ?)',current_user.account.id.to_s, params[:callerid], params[:callerid], params[:callerid]).first
    @notes = Note.all.where(client_id: @client).order(id: :desc)

  end


  def updateinfo
  @client = Client.find_by(id: params[:clientid])
if @client == nil
puts "Lets Create"
  @client = Client.new
  @client.account = current_user.account
end

if @client != nil
puts params[:clientid]
puts params[:firstname]
puts params[:lastname]

puts params[:phone1]
puts params[:phone2]
puts params[:phone3]

puts params[:email]
puts params[:idnum]
puts params[:birthday]


puts params[:country]
puts params[:city]
puts params[:address]

@client.firstname =  params[:firstname]
@client.lastname =   params[:lastname]

@client.phone1 =   params[:phone1]
@client.phone2 =   params[:phone2]
@client.phone3 =   params[:phone3]

@client.email =   params[:email]
@client.idnum =   params[:idnum]
@client.birthday =   params[:birthday]


@client.country =   params[:country]
@client.city =   params[:city]
@client.address =   params[:address]
puts @client
puts "Lets Save"
#@client.save
     if @client.save
puts "OK"
render plain: "OK"
      else
puts "Not OK"
puts @sip.errors
render plain: "Not OK"
      end

#    @client.phone1 = params[:callerid]
  end
  end

def addnote
@client = Client.find_by(id: params[:clientid])
if @client == nil
 render plain: "Not OK"
else
 note = Note.new
 note.client_id = @client.id
 note.user_id = current_user.id
 note.subject =  params[:subject]
 note.callid =  params[:callid]
 note.body =  params[:body]
 if note.save
  render plain: "OK"
 else
  render plain: "Not OK"
 end
end
end



def addcallnote
 comment = Comment.new
 comment.account = current_user.account
 comment.callid = params[:callid]
 comment.user_id = current_user.id
 comment.status =  params[:status]
 comment.category_id =  params[:category]
 comment.body =  params[:body]
 if comment.save
  render plain: "OK"
 else
  render plain: "Not OK"
 end
end


def getstat
puts current_user.username
agent = "SIP/" + current_user.username
@startdate = Date.today.to_s + ' 00:00:00'
@stopdate = Date.today.to_s + ' 23:59:59'


agentsresult = Queuelog.group(:agent).select("agent,sum(if(event='RINGNOANSWER',1,0)) as missed,sum(if(event='CONNECT',1,0)) as answered,sec_to_time(sum(if(event in('COMPLETEAGENT','COMPLETECALLER'),data2,if(event in('ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER'),data4,0)))) as totdur,sec_to_time(sum(if(event in('COMPLETEAGENT','COMPLETECALLER'),data2,if(event in('ATTENDEDTRANSFER','BLINDTRANSFER','TRANSFER'),data4,0))) /sum(if(event ='CONNECT',1,0))) as avgdur, sec_to_time(sum(if(event ='CONNECT',data3,0))/sum(if(event ='CONNECT',1,0))) as avganswer").where(['time >= ? and time < ? and agent=?',@startdate,@stopdate,agent])
agentsresultrow = agentsresult[0]
if agentsresultrow != nil
@missednum = agentsresult[0].missed.to_s
@answerednum = agentsresult[0].answered.to_s
@totaltime = agentsresult[0].totdur.to_s[11,8]
@avgtime  = agentsresult[0].avgdur.to_s[11,8]
@avganswer  = agentsresult[0].avganswer.to_s[11,8]
perc = ((agentsresult[0].missed.to_f + agentsresult[0].answered.to_f)/100)
@allnum  =  (agentsresult[0].missed + agentsresult[0].answered).to_s
@sla = (agentsresult[0].answered.to_f / perc).round(2).to_s
puts "#{@missednum} #{@answerednum} #{@allnum} #{@sla} #{@totaltime} #{@avgtime} #{@avganswer}"
end

agentscdrresultout = Cdr.group(:src).select("src,count(*) as data1,sum(if(billsec>0,1,0)) as data2,sec_to_time(sum(billsec)) as data3,sec_to_time(sum(billsec) /sum(if(billsec>0,1,0))) as data4").where(['dcontext = "pbxout" and accountcode = ?  and created_at >= ? and created_at < ? and src = ?',current_user.account.id.to_s,@startdate,@stopdate,current_user.username[4..]])

agentscdrresultoutrow = agentscdrresultout[0]
if agentscdrresultoutrow != nil
@answerednumout = agentscdrresultoutrow.data2.to_s
@allnumout = agentscdrresultoutrow.data1.to_s
@missednumout = (agentscdrresultoutrow.data1 - agentscdrresultoutrow.data2).to_s
percout = (agentscdrresultoutrow.data1.to_f / 100)
@slaout = (agentscdrresultoutrow.data2.to_f / percout).round(2).to_s
@totaltimeout = agentscdrresultoutrow.data3.to_s[11,8]
@avgtimeout = agentscdrresultoutrow.data4.to_s[11,8]
end


end
end
