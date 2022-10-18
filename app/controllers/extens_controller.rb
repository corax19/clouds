class ExtensController < ApplicationController
  before_action :set_exten, only: %i[ show edit update destroy ]
  before_action :getPermissions
  before_action :checkPermissions
  # GET /extens or /extens.json
  def index
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
