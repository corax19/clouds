class AccountsController < ApplicationController
before_action :authenticate_user!

def index
end


def show
@account = Account.find_by(id: current_user.account.id)
end


  def updatemyaccount
 @myaccount = current_user.account
    respond_to do |format|
      if @myaccount.update(myaccount_params)
        Log.create(account: current_user.account, user: current_user, event: "updatemyaccount", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to myaccount_path, notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @myaccount }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @myaccount.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Only allow a list of trusted parameters through.
    def myaccount_params
      params.require(:account).permit(:name, :phone, :address, :image)
    end


end
