source 'https://rubygems.org'

ruby '2.4.5'


gem 'rails', github: 'rails/rails', branch: '4-2-stable'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

# 追加gem
gem 'bootstrap-sass' # 5.1.2にて
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# devのみでないとエラー
gem 'web-console', group: :development


group :development, :test do
  gem 'sqlite3', '~> 1.3.0'
  gem 'byebug'
  gem 'spring'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

group :production do
  gem 'pg', '0.19.0'
  gem 'rails_12factor', '0.0.2'
  gem 'puma'
end

