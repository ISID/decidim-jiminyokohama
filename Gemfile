# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
gem 'omniauth-line'
gem "decidim", "0.21.0"
gem 'line-bot-api'

gem "bootsnap", "~> 1.3"
gem "nokogiri", "1.10.9"
gem "puma", "~> 4.3.3"
gem "uglifier", "~> 4.1"
gem 'decidim-user_extension', path: 'decidim-user_extension'
gem 'deface'
gem "faker", "~> 1.9"
gem 'activerecord-session_store'
gem 'rails', '5.2.4.4'

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "decidim-dev", "0.21.0"
end

group :development do
  gem 'pry-rails'
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end

group :production do
  gem 'sidekiq', '~> 5.2', '>= 5.2.7'
  gem "passenger"
  gem 'delayed_job_active_record'
  gem "daemons"
  gem 'rack-cors'
  gem "secure_headers"
  gem "fog-aws"
end
