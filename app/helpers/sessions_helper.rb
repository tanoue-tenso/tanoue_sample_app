module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ログイン中のみログインユーザーを返す
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) #
  end

  # ログインしてる？
  def logged_in?
    current_user.present?
  end
end
