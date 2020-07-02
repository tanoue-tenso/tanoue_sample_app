module ApplicationHelper

  # ここにview内で呼び出せるヘルパー関数を定義できる
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    return page_title.empty? ? base_title : page_title + " | " + base_title
  end

end
