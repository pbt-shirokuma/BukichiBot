# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "rails", "5.2.3"
gem "bootsnap", "1.4.4" , require: false
gem "listen" , "3.1.5"
gem 'puma' , "4.0.0"
gem 'aws-sdk-rails' , "2.1.0"
gem 'aws-sdk-s3' , "1.45.0"
gem 'line-bot-api' , "1.11.0"
gem 'active_hash' , "2.2.1"
gem 'json' , '2.3.0'
gem 'uglifier' , "4.1.20"
gem 'materialize-sass', '~> 1.0.0'
gem 'material_icons', '~> 2.2.1'
gem 'sass-rails'
gem 'jquery-rails'
gem 'enum_help'
gem 'sassc', '~>2.1.0'
gem 'font-awesome-rails'

group :test do
  gem 'rspec-rails' , "3.8.2"
  gem 'mysql2' , "0.5.2"
  gem 'factory_bot_rails'
  gem 'database_cleaner'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'mysql2' , "0.5.2"
  gem 'pry-rails' 
  gem 'pry-doc' 
  gem 'pry-byebug' 
  gem 'pry-stack_explorer'
  gem 'annotate'
end

group :production do
  gem 'pg' , "1.1.4"
end