class AgentsController < ApplicationController
before_action :authenticate_user!
 before_action :getPermissions
 before_action :checkPermissions
 before_action :set_agent, only: %i[ show edit update destroy ]




  # GET /agents or /agents.json
  def index

uri = URI.parse("http://localhost:8088/ari/endpoints/SIP")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
request.basic_auth("sasha", "qscesz")
res = http.request(request)
@sipsonline={}

if res.body != nil
sips =  JSON.parse(res.body)
sips.each do |value|
@sipsonline[value["resource"]] = value["state"]
end

end



    @agents = Agent.all.where(account_id: current_user.account.id,hotline: params[:queueid])
    @hotline = Hotline.find(params[:queueid])
  end

  # GET /agents/1 or /agents/1.json
  def show
  end

  # GET /agents/new
  def new
    @agent = Agent.new
@agent.account = current_user.account
@agent.hotline_id = params[:queueid]

  end

  # GET /agents/1/edit
  def edit
  end

  # POST /agents or /agents.json
  def create
    @agent = Agent.new(agent_params)
@agent.account = current_user.account
@agent.hotline_id = params[:queueid]

@agent.name = Hotline.find_by(id: @agent.hotline_id).name
@agent.queue_name = Hotline.find_by(id: @agent.hotline_id).name

if Rails.configuration.isinhouse == "Yes"
@agent.interface = "SIP/" +  Exten.find_by(id: @agent.exten_id).exten
@agent.membername = "SIP/" + Exten.find_by(id: @agent.exten_id).exten
else
@agent.interface = "SIP/" + current_user.account.id.to_s + Exten.find_by(id: @agent.exten_id).exten
@agent.membername = "SIP/" + current_user.account.id.to_s + Exten.find_by(id: @agent.exten_id).exten
end

    respond_to do |format|
      if @agent.save

@agent.uniqueid = @agent.id
@agent.save

        Log.create(account: current_user.account, user: current_user, event: "createagent", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to agents_path(@agent.hotline_id), notice: "Agent was successfully created." }
        format.json { render :show, status: :created, location: @agent }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @agent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /agents/1 or /agents/1.json
  def update

@agent.name = Hotline.find_by(id: @agent.hotline_id).name
@agent.queue_name = Hotline.find_by(id: @agent.hotline_id).name
if Rails.configuration.isinhouse == "Yes"
@agent.interface = "SIP/" +  Exten.find_by(id: @agent.exten_id).exten
@agent.membername = "SIP/" +  Exten.find_by(id: @agent.exten_id).exten
else
@agent.interface = "SIP/" + current_user.account.id.to_s + Exten.find_by(id: @agent.exten_id).exten
@agent.membername = "SIP/" + current_user.account.id.to_s + Exten.find_by(id: @agent.exten_id).exten
end

    respond_to do |format|
      if @agent.update(agent_params)
        Log.create(account: current_user.account, user: current_user, event: "updateagent", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to agents_path(@agent.hotline_id), notice: "Agent was successfully updated." }
        format.json { render :show, status: :ok, location: @agent }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @agent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agents/1 or /agents/1.json
  def destroy
    @agent.destroy
        Log.create(account: current_user.account, user: current_user, event: "destroyagent", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    respond_to do |format|
      format.html { redirect_to agents_url, notice: "Agent was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent
      @agent = Agent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def agent_params
      params.require(:agent).permit(:account_id, :hotline_id, :exten_id, :penalty)
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
