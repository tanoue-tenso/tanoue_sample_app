class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # debugger こいつを差し込むことでレスポンスを送る前にターミナル上で変数の中身とかを見ることができる
  end

  def new
  end
end
