source 'https://rubygems.org'

ruby '2.2.3'

gem 'rails', '3.2.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'docker-api'

# # Gems used only for assets and not required
# # in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'sinatra', :require => nil #sidekiq web ui
gem 'sidekiq'

gem 'activeadmin'
gem "meta_search", '>= 1.1.0.pre'

# Use unicorn as the app server
gem 'unicorn'

gem "sentry-raven", :github => 'getsentry/raven-ruby'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
end
