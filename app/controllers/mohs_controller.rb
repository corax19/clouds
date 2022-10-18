class MohsController < ApplicationController
 before_action :getPermissions
 before_action :checkPermissions
 before_action :set_moh, only: %i[ show edit update destroy ]

  # GET /mohs or /mohs.json
  def index
    @mohs = Moh.all.where(account_id: current_user.account.id)
  end

  # GET /mohs/1 or /mohs/1.json
  def show
  end

  # GET /mohs/new
  def new
    @moh = Moh.new
  end

  # GET /mohs/1/edit
  def edit
  end

  # POST /mohs or /mohs.json
  def create
    @moh = Moh.new(moh_params)
    @moh.account = current_user.account
    respond_to do |format|
      if @moh.save
        Log.create(account: current_user.account, user: current_user, event: "createmoh", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to mohs_path, notice: "Moh was successfully created." }
        format.json { render :show, status: :created, location: @moh }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @moh.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mohs/1 or /mohs/1.json
  def update
    respond_to do |format|
      if @moh.update(moh_params)
        Log.create(account: current_user.account, user: current_user, event: "updatemoh", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to mohs_path, notice: "Moh was successfully updated." }
        format.json { render :show, status: :ok, location: @moh }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @moh.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mohs/1 or /mohs/1.json
  def destroy
    @moh.destroy
    Log.create(account: current_user.account, user: current_user, event: "destroymoh", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    respond_to do |format|
      format.html { redirect_to mohs_url, notice: "Moh was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_moh
      @moh = Moh.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def moh_params
      params.require(:moh).permit(:name, :description)
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
unless @userpermissions['permission_mohs'] == 1
render :file => "#{Rails.root}/public/errors/404.html",  :status => 404
end
end


end
