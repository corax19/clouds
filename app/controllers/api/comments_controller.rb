class Api::CommentsController < ApplicationController
before_action :check_token
skip_before_action :verify_authenticity_token

def index
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    startdate = params[:startdate] + ' 00:00:00'
    stopdate = params[:stopdate] + ' 23:59:59'
    cdrs = Comment.all.where('account_id = ? and created_at between ? and ?',account.id,startdate,stopdate).select("id, callid, status, (select title from categories where id = comments.category_id) as title, body, created_at")
    render json: cdrs
end

def show
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    startdate = params[:startdate] + ' 00:00:00'
    stopdate = params[:stopdate] + ' 23:59:59'
    cdrs = Comment.all.where('account_id = ? and callid = ?',account.id,params[:callid]).select("id, callid, status, (select title from categories where id = comments.category_id) as title, body, created_at")
    render json: cdrs
end

  def destroy
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    comment = Comment.find_by(id: params[:id])
    if comment == nil
    render plain: "Comment Not Found"
    else
    comment.destroy
    Log.create(account: account, user: User.where('account_id = ? and isadmin>=0',account.id).first, event: "apidestroycomment", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    render plain: "Comment was successfully destroyed."
    end
  end

  def create
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    comment = Comment.new
    comment.account_id = account.id
    comment.user_id = User.where('account_id = ? and isadmin>=0',account.id).first.id
    comment.callid = params[:callid] if params[:callid] != nil
    comment.status = params[:status] if params[:status] != nil
    comment.category_id = Category.find_by(title:  params[:category]).id if params[:category] != nil
    comment.body = params[:body] if params[:body] != nil
    comment.save
    Log.create(account: account, user: User.where('account_id = ? and isadmin>=0',account.id).first, event: "apicreatecomment", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    render plain: "Client was successfully created."
  end

  def update
    token = request.headers['Authorization'].split(' ').last
    account = Account.find_by(token: token)
    comment = Comment.find_by(id: params[:id])
    comment.status = params[:status] if params[:status] != nil
    comment.category_id = Category.find_by(title:  params[:category]).id if params[:category] != nil
    comment.body = params[:body] if params[:body] != nil
    comment.save
    Log.create(account: account, user: User.where('account_id = ? and isadmin>=0',account.id).first, event: "apicreatecomment", data: params.to_json,url: request.fullpath, ipaddr: request.remote_ip)
    render plain: "Client was successfully created."
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