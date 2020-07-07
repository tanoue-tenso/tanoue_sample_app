class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember user
      redirect_to user # redirect_to user_url(user)
    else
      flash.now[:danger] = 'Invalid emai/password combination'
      render 'new' # リダイレクトではない => リクエストを送らないのでflashが消えない
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
