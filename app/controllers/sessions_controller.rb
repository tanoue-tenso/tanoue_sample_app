class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ログイン後にリダイレクト
    else
      flash.now[:danger] = 'Invalid emai/password combination'
      render 'new' # リダイレクトではない => リクエストを送らないのでflashが消えない
    end
  end

  def destory

  end
end
