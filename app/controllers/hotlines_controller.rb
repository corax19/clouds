class HotlinesController < ApplicationController
before_action :authenticate_user!
 before_action :getPermissions
 before_action :checkPermissions
 before_action :set_hotline, only: %i[ show edit update destroy ]

  # GET /hotlines or /hotlines.json
  def index
    @hotlines = Hotline.all.where(account_id: current_user.account.id)
  end

  # GET /hotlines/1 or /hotlines/1.json
  def show
  end

  # GET /hotlines/new
  def new
    @hotline = Hotline.new
  end

  # GET /hotlines/1/edit
  def edit
  end

  # POST /hotlines or /hotlines.json
  def create
    @hotline = Hotline.new(hotline_params)
    @hotline.account = current_user.account
    @hotline.name="#{@hotline.account.id}_#{@hotline.title}"
    if params[:hotline]["moh_id"] == nil || params[:hotline]["moh_id"] == ""
     @hotline.musiconhold = "default"
    else
     @hotline.musiconhold="#{@hotline.account.id}_#{params[:hotline]["moh_id"]}"
    end
    respond_to do |format|
      if @hotline.save
        Log.create(account: current_user.account, user: current_user, event: "createqueue", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to hotlines_path, notice: "Hotline was successfully created." }
        format.json { render :show, status: :created, location: @hotline }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @hotline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hotlines/1 or /hotlines/1.json
  def update
  @hotline.name="#{@hotline.account.id}_#{@hotline.title}"
    if params[:hotline]["moh_id"] == nil || params[:hotline]["moh_id"] == ""
     @hotline.musiconhold = "default"
    else
     @hotline.musiconhold="#{@hotline.account.id}_#{params[:hotline]["moh_id"]}"
    end


    respond_to do |format|
      if @hotline.update(hotline_params)
        Log.create(account: current_user.account, user: current_user, event: "updatequeue", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to hotlines_path, notice: "Hotline was successfully updated." }
        format.json { render :show, status: :ok, location: @hotline }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @hotline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hotlines/1 or /hotlines/1.json
  def destroy
    @hotline.destroy
        Log.create(account: current_user.account, user: current_user, event: "destroyqueue", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    respond_to do |format|
      format.html { redirect_to hotlines_url, notice: "Hotline was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hotline
      @hotline = Hotline.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hotline_params
      params.require(:hotline).permit(:name, :title, :strategy, :timeout, :retry, :wrapuptime, :maxlen, :moh_id, :musiconhold, :maxtime)
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
unless @userpermissions['permission_queues'] == 1
render :file => "#{Rails.root}/public/errors/404.html",  :status => 404
end
end



end
