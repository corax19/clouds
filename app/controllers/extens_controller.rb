class ExtensController < ApplicationController
before_action :authenticate_user!
 before_action :getPermissions
 before_action :checkPermissions

  before_action :set_exten, only: %i[ show edit update destroy ]
  # GET /extens or /extens.json
  def index

uri = URI.parse("http://localhost:8088/ari/endpoints/SIP")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("sasha", "qscesz")
res = http.request(request)
sips =  JSON.parse(res.body)
@sipsonline={}
sips.each do |value|
@sipsonline[value["resource"]] = value["state"]
end


    @extens = Exten.all.where(account_id: current_user.account.id)
  end

  # GET /extens/1 or /extens/1.json
  def show
  end

  # GET /extens/new
  def new
    @exten = Exten.new
  end

  # GET /extens/1/edit
  def edit
  end

  # POST /extens or /extens.json
  def create
    @exten = Exten.new(exten_params)
@exten.account = current_user.account
    respond_to do |format|
      if @exten.save

if params[:exten]["voicemail"] == "Yes"
  @exten.voicemail=Voicemail.create(context: "default", mailbox: current_user.account_id.to_s+@exten.exten.to_s, password: params[:exten]["vmsecret"], email: params[:exten]["vmemail"], attach: "yes", exten: @exten)
end


        Log.create(account: current_user.account, user: current_user, event: "createexten", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to extens_path, notice: "Exten was successfully created." }
        format.json { render :show, status: :created, location: @exten }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @exten.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /extens/1 or /extens/1.json
  def update
    respond_to do |format|
      if @exten.update(exten_params)


if params[:exten]["voicemail"] == "Yes"
 if @exten.voicemail == nil
  @exten.voicemail=Voicemail.create(context: "default", mailbox: current_user.account_id.to_s+@exten.exten.to_s, password: params[:exten]["vmsecret"], email: params[:exten]["vmemail"], attach: "yes", exten: @exten)
 else
  @exten.voicemail.update(password: params[:exten]["vmsecret"], email: params[:exten]["vmemail"])
 end
else

 if @exten.voicemail != nil
  @exten.voicemail.destroy
 end

end




        Log.create(account: current_user.account, user: current_user, event: "updateexten", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to extens_path, notice: "Exten was successfully updated." }
        format.json { render :show, status: :ok, location: @exten }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @exten.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /extens/1 or /extens/1.json
  def destroy
    @exten.destroy
        Log.create(account: current_user.account, user: current_user, event: "destroyexten", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    respond_to do |format|
      format.html { redirect_to extens_url, notice: "Exten was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exten
      @exten = Exten.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def exten_params
      params.require(:exten).permit(:exten, :secret, :name, :decription, :account_id, :sip_id, :record, :calllimit)
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
unless @userpermissions['permission_extensions'] == 1
render :file => "#{Rails.root}/public/errors/404.html",  :status => 404
end
end

end
