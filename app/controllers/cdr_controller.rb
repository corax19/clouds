class CdrController < ApplicationController
  def index
  end


  def search
  @startdate=params[:startdate]
  @stopdate=params[:stopdate]
  @caller=params[:caller]
  @called=params[:called]
  @direction=params[:direction]
  end

end
