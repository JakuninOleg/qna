require 'rails_helper'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.include AcceptanceHelper, type: :feature

  Capybara.javascript_driver = :selenium_chrome_headless

  Capybara.server = :puma

  ActionDispatch::IntegrationTest
  Capybara.server_port = 3001
  Capybara.app_host = 'http://localhost:3001'
end
