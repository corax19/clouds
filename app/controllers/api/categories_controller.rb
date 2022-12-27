class Api::CategoriesController < ApplicationController
before_action :check_token
skip_before_action :verify_authenticity_token

def index
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    startdate = params[:startdate] + ' 00:00:00'
    stopdate = params[:stopdate] + ' 23:59:59'
    categories = Category.all.where('account_id = ?',account.id).select("id, title, description, status, created_at")
    render json: categories
end

  def destroy
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    category = Category.where(account_id: account.id).find_by(id: params[:id])
    if category == nil
    render plain: "Category Not Found"
    else
    category.destroy
    Log.create(account: account, user: User.where('account_id = ? and isadmin>=0',account.id).first, event: "apidestroycategory", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    render plain: "Category was successfully destroyed."
    end
  end


  def update
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    category = Category.where(account_id: account.id).find_by(id: params[:id])
    category.title = params[:title] if params[:title] != nil
    category.description = params[:description] if params[:description] != nil
    category.status = params[:status] if params[:status] != nil
    category.save
    Log.create(account: account, user: User.where('account_id = ? and isadmin>=0',account.id).first, event: "apiupdatecategory", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    render plain: "Category was successfully updated."
  end

  def create
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    category = Category.new
    category.account_id = account.id
    category.title = params[:title] if params[:title] != nil
    category.description = params[:description] if params[:description] != nil
    category.status = params[:status] if params[:status] != nil
    category.save
    Log.create(account: account, user: User.where('account_id = ? and isadmin>=0',account.id).first, event: "apicreatecategory", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    render plain: "Category was successfully created."
  end



def check_token
    if request.headers['Authorization'] == nil
    render plain: "Invalid token"
    else
    token = request.headers['Authorization'].split(' ').last
    if token == nil
    render plain: "Invalid token"
    else
    if token == nil
    render plain: "Account Not Found"
    else
    account = Account.find_by(token: token)
    if account == nil
    render plain: "Account Not Found"
    else
    unless account.apiips.split(/\r\n/).include? request.remote_ip
    render plain: "Your IP isn't allowed for this API"
    end
    end
    end
    end
    end
end

end