require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:tanos)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # メアドが無効
    post password_resets_path, password_reset: { email: 'hoge'}
    assert_not flash.empty?
    # メアド有効
    post password_resets_path, password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    # メールクリックして再設定用フォームへ
    user = assigns(:user)
    # メアドが無効
    get edit_password_reset_path(user.reset_token, email: "hoge")
    assert_redirected_to root_url
    # 無効なユーザー
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    # メアド,ゆーざーは正しいけどトークンは無効
    user.toggle!(:activated)
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # 全て有効な場合
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # 編集フォームからパスワード更新へ
    # 無効なパスワード
    patch password_reset_path(user.reset_token), {
      email: user.email,
      user: {
        password: "foobaz",
        password_confirmation: "hgoe"
      }
    }
    assert_select 'div#error_explanation'
    # パスワードが空
    patch password_reset_path(user.reset_token), {
      email: user.email,
      user: {
        password: "",
        password_confirmation: ""
      }
    }
    assert_select 'div#error_explanation'
    # パスワードが有効な場合
    patch password_reset_path(user.reset_token), {
      email: user.email,
      user: {
        password: "password",
        password_confirmation: "password"
      }
    }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
