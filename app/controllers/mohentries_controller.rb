class MohentriesController < ApplicationController
 before_action :getPermissions
 before_action :checkPermissions
 before_action :set_mohentry, only: %i[ destroy ]

  # GET /agents or /agents.json
  def index
    @mohentries = MohEntry.all.where(account_id: current_user.account.id,moh: params[:mohid])
    @moh = Moh.find(params[:mohid])
  end

  def new
    @mohentry = MohEntry.new
    @mohentry.account = current_user.account
    @mohentry.moh_id = params[:mohid]
  end




  def create
    @mohentry = MohEntry.new(mohentry_params)
    @mohentry.account = current_user.account
    @mohentry.moh_id = params[:mohid]
    respond_to do |format|
      if @mohentry.save
        format.html { redirect_to mohentries_path(@mohentry.moh_id), notice: "MOH ENtry was successfully created." }
        format.json { render :show, status: :created, location: @agent }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @agent.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /agents/1 or /agents/1.json
  def destroy
    @mohentry.destroy

    respond_to do |format|
      format.html { redirect_to mohentries_path(params[:mohid]), notice: "MOH Entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mohentry
      @mohentry = MohEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mohentry_params
      params.require(:moh_entry).permit(:account_id, :moh_id, :sound_id)
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
