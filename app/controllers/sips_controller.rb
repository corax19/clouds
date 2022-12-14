class SipsController < ApplicationController
before_action :authenticate_user!
 before_action :getPermissions
 before_action :checkPermissions

  before_action :set_sip, only: %i[ show edit update destroy ]

  # GET /sips or /sips.json
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
    @sips = Sip.all.where(account_id: current_user.account.id)
end

  # GET /sips/1 or /sips/1.json
  def show
  end

  # GET /sips/new
  def new
    @sip = Sip.new
  end

  # GET /sips/1/edit
  def edit
  end

  # POST /sips or /sips.json
  def create
    @sip = Sip.new(sip_params)
    @sip.account = current_user.account
    respond_to do |format|
      if @sip.save
puts "Create route"
        Route.create(account_id: current_user.account.id,name: "DEFAULT", sip: @sip)
        Log.create(account_id: current_user.account.id, user: current_user, event: "createsip", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to sips_path, notice: "Sip was successfully created." }
        format.json { render :show, status: :created, location: @sip }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sips/1 or /sips/1.json
  def update
    respond_to do |format|
      if @sip.update(sip_params)
        Log.create(account: current_user.account, user: current_user, event: "updatesip", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to sips_path, notice: "Sip was successfully updated." }
        format.json { render :show, status: :ok, location: @sip }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sips/1 or /sips/1.json
  def destroy
#ActiveRecord::Base.connection.execute 'SET FOREIGN_KEY_CHECKS=0;'
    @sip.destroy
#ActiveRecord::Base.connection.execute 'SET FOREIGN_KEY_CHECKS=1;'
    Log.create(account: current_user.account, user: current_user, event: "destroysip", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    respond_to do |format|
      format.html { redirect_to sips_url, notice: "Sip was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sip
      @sip = Sip.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sip_params
      params.require(:sip).permit(:sipid, :secret, :host, :number, :decription)
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
unless @userpermissions['permission_sips'] == 1
render :file => "#{Rails.root}/public/errors/404.html",  :status => 404
end
end

end
