class StepsController < ApplicationController
 before_action :getPermissions
 before_action :checkPermissions

  before_action :set_step, only: %i[ show edit editplayback editdial editdialexternal editmenu editqueue editread updatedial updatemenu updatequeue updatedialexternal updateplayback updateread update destroy stepup stepdown]
  before_action :set_newstep, only: %i[ new newplayback newread newdial newqueue newdialexternal newmenu]
  # GET /steps or /steps.json
  def index
    @steps = Step.all.where(account_id: current_user.account.id,route: params[:routeid]).order(:stepnum,:id)
    @route = Route.find(params[:routeid])


  end

  # GET /steps/1 or /steps/1.json
  def show
    @route = Route.find(params[:routeid])
  end


  def stepup
  step1 = Step.find(params[:id])
  if step1.stepnum >1
   stepnum1 = step1.stepnum
   stepnum2 = stepnum1 - 1
   step2 = Step.find_by(route_id: params[:routeid], stepnum: stepnum2)
   step1.stepnum = stepnum2
   step2.stepnum = stepnum1
   step1.save
   step2.save
  end
  redirect_to steps_path(params[:routeid])

  end


  def stepdown
  @steps = Step.all.where(account_id: current_user.account.id,route: params[:routeid])
    step1 = Step.find(params[:id])

   if step1.stepnum < @steps.count
    stepnum1 = step1.stepnum
    stepnum2 = stepnum1 + 1
    step2 = Step.find_by(route_id: params[:routeid], stepnum: stepnum2)
   step1.stepnum = stepnum2
   step2.stepnum = stepnum1
   step1.save
   step2.save
   end
  redirect_to steps_path(params[:routeid])

  end










  # GET /steps/new
  def new
  end


  def newplayback
  end

  def newread
  end

  def newdial
  end


  def newmenu
  end




  def newdialexternal
  end


  # GET /steps/1/edit
  def edit
  end

  def editplayback
  end

  def editdial
  end


  # POST /steps or /steps.json
  def create
    @step = Step.new(step_params)
@step.account = current_user.account
@step.route_id = params[:routeid]


    respond_to do |format|
      if @step.save
        rearrange
        format.html { redirect_to steps_path(@step.route_id), notice: "Step was successfully created." }
        format.json { render :show, status: :created, location: @step }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end


def createplayback
@step = Step.new(step_params)
@step.account = current_user.account
@step.route_id = params[:routeid]

stepdata=Array.new
params[:step].each do |id, value|
if id == "sound_id"
stepdata.push(["soundfile", value])
end
end
@step.data = stepdata.to_json
    respond_to do |format|
      if @step.save
        rearrange
        Log.create(account: current_user.account, user: current_user, event: "createstepplayback", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to steps_path(@step.route_id), notice: "Step was successfully created." }
        format.json { render :show, status: :created, location: @step }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end


def createread
@step = Step.new(step_params)
@step.account = current_user.account
@step.route_id = params[:routeid]

stepdata=Array.new
params[:step].each do |id, value|
puts value
if id == "sound_id"
stepdata.push(["soundfile", value])
end

if id == "maxlen"
stepdata.push(["maxlen", value])
end

if id == "timeout"
stepdata.push(["timeout", value])
end

if id == "read0"
stepdata.push(["read0", value])
end

if id == "read1"
stepdata.push(["read1", value])
end
if id == "read2"
stepdata.push(["read2", value])
end
if id == "read3"
stepdata.push(["read3", value])
end
if id == "read4"
stepdata.push(["read4", value])
end

if id == "read5"
stepdata.push(["read5", value])
end

if id == "read6"
stepdata.push(["read6", value])
end
if id == "read7"
stepdata.push(["read7", value])
end
if id == "read8"
stepdata.push(["read8", value])
end
if id == "read9"
stepdata.push(["read9", value])
end


end
@step.data = stepdata.to_json
puts @step.data
    respond_to do |format|
      if @step.save
        rearrange
        Log.create(account: current_user.account, user: current_user, event: "createstepread", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to steps_path(@step.route_id), notice: "Step was successfully created." }
        format.json { render :show, status: :created, location: @step }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end


def createmenu
@step = Step.new(step_params)
@step.account = current_user.account
@step.route_id = params[:routeid]

stepdata=Array.new
params[:step].each do |id, value|
if id == "menu_id"
stepdata.push(["menu", value])
end
end
@step.data = stepdata.to_json
    respond_to do |format|
      if @step.save
        rearrange
        Log.create(account: current_user.account, user: current_user, event: "createstepmenu", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to steps_path(@step.route_id), notice: "Step was successfully created." }
        format.json { render :show, status: :created, location: @step }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end


def createdial
@step = Step.new(step_params)
@step.account = current_user.account
@step.route_id = params[:routeid]
exten_num = ""
puts "Spdating step Dial"
stepdata=Array.new
params[:step].each do |id, value|
if id == "exten_id"
puts value
stepdata.push(["exten_id", value])
exten_num = Exten.find_by(id: value).exten
end

if id == "timeout"
puts value
stepdata.push(["timeout", value])
end

if id == "options"
puts value
stepdata.push(["options", value])
end

end

stepdata.push(["exten_num", exten_num])

@step.data = stepdata.to_json
    respond_to do |format|
      if @step.save
        rearrange
        Log.create(account: current_user.account, user: current_user, event: "createstepdial", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to steps_path(@step.route_id), notice: "Step was successfully created." }
        format.json { render :show, status: :created, location: @step }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
end




def createqueue
@step = Step.new(step_params)
@step.account = current_user.account
@step.route_id = params[:routeid]
hotline_name = ""
stepdata=Array.new
params[:step].each do |id, value|
if id == "hotline"
stepdata.push(["hotline_id", value])
hotline_name = Hotline.find_by(id: value).name
end

if id == "options"
stepdata.push(["options", value])
end

end

stepdata.push(["hotline_name", hotline_name])

@step.data = stepdata.to_json
    respond_to do |format|
      if @step.save
        rearrange
        Log.create(account: current_user.account, user: current_user, event: "createstepqueue", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to steps_path(@step.route_id), notice: "Step was successfully created." }
        format.json { render :show, status: :created, location: @step }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
end







def createdialexternal
@step = Step.new(step_params)
@step.account = current_user.account
@step.route_id = params[:routeid]
sipid = ""
stepdata=Array.new
params[:step].each do |id, value|
if id == "number"
stepdata.push(["number", value])
end

if id == "sip_id"
stepdata.push(["sip_id", value])
sipid = Sip.find_by(id: value).sipid
end

if id == "timeout"
stepdata.push(["timeout", value])
end

if id == "options"
stepdata.push(["options", value])
end

end


stepdata.push(["sipid", sipid])

@step.data = stepdata.to_json
    respond_to do |format|
      if @step.save
        rearrange
        Log.create(account: current_user.account, user: current_user, event: "createstepexternal", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to steps_path(@step.route_id), notice: "Step was successfully created." }
        format.json { render :show, status: :created, location: @step }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
end



def updatedial
stepdata=Array.new
exten_num = 0
params[:step].each do |id, value|
puts id, value
if id == "exten_id"
stepdata.push(["exten_id", value])
exten_num = Exten.find_by(id: value).exten
end
if id == "timeout"
stepdata.push(["timeout", value])
end
if id == "options"
stepdata.push(["options", value])
end

end

stepdata.push(["exten_num", exten_num])

@step.data = stepdata.to_json


    respond_to do |format|
      if @step.update(step_params)
        Log.create(account: current_user.account, user: current_user, event: "updatestepdial", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to steps_path(@step.route_id), notice: "Step was successfully updated." }
        format.json { render :show, status: :ok, location: @step }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
end


def updatequeue
stepdata=Array.new
hotline_name = ""
params[:step].each do |id, value|
puts id, value
if id == "hotline"
puts value
stepdata.push(["hotline_id", value])
hotline_name = Hotline.find_by(id: value).name
end
if id == "options"
puts value
stepdata.push(["options", value])
end

end

stepdata.push(["hotline_name", hotline_name])


@step.data = stepdata.to_json


    respond_to do |format|
      if @step.update(step_params)
        Log.create(account: current_user.account, user: current_user, event: "updatestepqueue", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to steps_path(@step.route_id), notice: "Step was successfully updated." }
        format.json { render :show, status: :ok, location: @step }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
end


def updateread
stepdata=Array.new

params[:step].each do |id, value|
puts id, value
if id == "sound_id"
stepdata.push(["soundfile", value])
end

if id == "maxlen"
stepdata.push(["maxlen", value])
end

if id == "timeout"
stepdata.push(["timeout", value])
end

if id == "read0"

if value[0..4] == "Menu_"
stepdata.push(["read0", value, Route.find_by(name: value[5..], account_id: current_user.account.id).id ])
else
stepdata.push(["read0", value])
end


end

if id == "read1"
if value[0..4] == "Menu_"
stepdata.push(["read1", value, Route.find_by(name: value[5..], account_id: current_user.account.id).id ])
else
stepdata.push(["read1", value])
end

end
if id == "read2"

if value[0..4] == "Menu_"
stepdata.push(["read2", value, Route.find_by(name: value[5..], account_id: current_user.account.id).id ])
else
stepdata.push(["read2", value])
end


end
if id == "read3"
if value[0..4] == "Menu_"
stepdata.push(["read3", value, Route.find_by(name: value[5..], account_id: current_user.account.id).id ])
else
stepdata.push(["read3", value])
end

end
if id == "read4"


if value[0..4] == "Menu_"
stepdata.push(["read4", value, Route.find_by(name: value[5..], account_id: current_user.account.id).id ])
else
stepdata.push(["read4", value])
end


end

if id == "read5"

if value[0..4] == "Menu_"
stepdata.push(["read5", value, Route.find_by(name: value[5..], account_id: current_user.account.id).id ])
else
stepdata.push(["read5", value])
end


end

if id == "read6"

if value[0..4] == "Menu_"
stepdata.push(["read6", value, Route.find_by(name: value[5..], account_id: current_user.account.id).id ])
else
stepdata.push(["read6", value])
end


end
if id == "read7"

if value[0..4] == "Menu_"
stepdata.push(["read7", value, Route.find_by(name: value[5..], account_id: current_user.account.id).id ])
else
stepdata.push(["read7", value])
end


end
if id == "read8"

if value[0..4] == "Menu_"
stepdata.push(["read8", value, Route.find_by(name: value[5..], account_id: current_user.account.id).id ])
else
stepdata.push(["read8", value])
end


end
if id == "read9"
if value[0..4] == "Menu_"
stepdata.push(["read9", value, Route.find_by(name: value[5..], account_id: current_user.account.id).id ])
else
stepdata.push(["read9", value])
end

end

end
@step.data = stepdata.to_json


    respond_to do |format|
      if @step.update(step_params)
        Log.create(account: current_user.account, user: current_user, event: "updatestepread", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to steps_path(@step.route_id), notice: "Step was successfully updated." }
        format.json { render :show, status: :ok, location: @step }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
end







def updatedialexternal
stepdata=Array.new
sipid= ""
params[:step].each do |id, value|
if id == "number"
stepdata.push(["number", value])
end

if id == "sip_id"
stepdata.push(["sip_id", value])
sipid = Sip.find_by(id: value).sipid
end

if id == "timeout"
stepdata.push(["timeout", value])
end

if id == "options"
stepdata.push(["options", value])
end

end


stepdata.push(["sipid", sipid])

@step.data = stepdata.to_json


    respond_to do |format|
      if @step.update(step_params)
        Log.create(account: current_user.account, user: current_user, event: "updatestepexternal", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to steps_path(@step.route_id), notice: "Step was successfully updated." }
        format.json { render :show, status: :ok, location: @step }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
end









def updateplayback
stepdata=Array.new
params[:step].each do |id, value|
if id == "sound_id"
stepdata.push(["soundfile", Sound.find_by(id: value).id])
end
end
@step.data = stepdata.to_json


    respond_to do |format|
      if @step.update(step_params)
        Log.create(account: current_user.account, user: current_user, event: "updatestepplayback", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to steps_path(@step.route_id), notice: "Step was successfully updated." }
        format.json { render :show, status: :ok, location: @step }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
end

def updatemenu
stepdata=Array.new
params[:step].each do |id, value|
if id == "menu_id"
stepdata.push(["menu", Route.find_by(id: value).id])
end
end
@step.data = stepdata.to_json


    respond_to do |format|
      if @step.update(step_params)
        Log.create(account: current_user.account, user: current_user, event: "updatestepmenu", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
        format.html { redirect_to steps_path(@step.route_id), notice: "Step was successfully updated." }
        format.json { render :show, status: :ok, location: @step }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
end



  # PATCH/PUT /steps/1 or /steps/1.json
  def update
    respond_to do |format|
      if @step.update(step_params)
        format.html { redirect_to steps_path(@step.route_id), notice: "Step was successfully updated." }
        format.json { render :show, status: :ok, location: @step }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end



  # PATCH/PUT /steps/1 or /steps/1.json
  def update
    respond_to do |format|
      if @step.update(step_params)
        format.html { redirect_to steps_path(@step.route_id), notice: "Step was successfully updated." }
        format.json { render :show, status: :ok, location: @step }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end







  # DELETE /steps/1 or /steps/1.json
  def destroy
    @step.destroy
    rearrange
    Log.create(account: current_user.account, user: current_user, event: "destroystep", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    respond_to do |format|
      format.html { redirect_to steps_url, notice: "Step was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def rearrange
   @steps = Step.all.where(account_id: current_user.account.id,route: params[:routeid]).order(:stepnum,:id)
   stepnum = 0
   @steps.each do |step|
    stepnum = stepnum + 1
    step.stepnum = stepnum
    step.save
   end

  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_step
      @step = Step.find(params[:id])
    end


    def set_newstep
      @step = Step.new
      @step.account = current_user.account
      @step.route_id = params[:routeid]
    end

    # Only allow a list of trusted parameters through.
    def step_params
      params.require(:step).permit(:event, :data)
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
unless @userpermissions['permission_steps'] == 1
render :file => "#{Rails.root}/public/errors/404.html",  :status => 404
end
end


end
