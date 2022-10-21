class RoutesController < ApplicationController
before_action :authenticate_user!
 before_action :getPermissions
 before_action :checkPermissions
 before_action :set_route, only: %i[ show edit update destroy ]

  # GET /routes or /routes.json
  def index
    @routes = Route.all.where(account_id: current_user.account.id)
  end

  # GET /routes/1 or /routes/1.json
  def show
  end

  # GET /routes/new
  def new
    @route = Route.new
  end

  # GET /routes/1/edit
  def edit
  end

  # POST /routes or /routes.json
  def create
    @route = Route.new(route_params)
@route.account = current_user.account
    respond_to do |format|
      if @route.save
        Log.create(account: current_user.account, user: current_user, event: "createroute", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to routes_path, notice: "Route was successfully created." }
        format.json { render :show, status: :created, location: @route }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /routes/1 or /routes/1.json
  def update
    respond_to do |format|
      if @route.update(route_params)
        Log.create(account: current_user.account, user: current_user, event: "updateroute", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to routes_path, notice: "Route was successfully updated." }
        format.json { render :show, status: :ok, location: @route }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /routes/1 or /routes/1.json
  def destroy
    @route.destroy
    Log.create(account: current_user.account, user: current_user, event: "destroyroute", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    respond_to do |format|
      format.html { redirect_to routes_url, notice: "Route was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_route
      @route = Route.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def route_params
      params.require(:route).permit(:sip_id, :name, :record, :day, :daystart, :daystop, :hourstart, :hourstop)
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
unless @userpermissions['permission_routes'] == 1
render :file => "#{Rails.root}/public/errors/404.html",  :status => 404
end
end





end
