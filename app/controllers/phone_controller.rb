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

end
