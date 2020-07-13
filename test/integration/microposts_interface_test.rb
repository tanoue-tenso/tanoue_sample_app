require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:tanos)
  end

  test 'micropost interface' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # 無効な通信(作成)
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: '' }
    end
    assert_select 'div#error_explanation'
    # 有効な通信(作成)
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: '有効な投稿' }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match '有効な投稿', response.body
    # 有効な通信(削除)
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザープロフィールにアクセス
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
end
