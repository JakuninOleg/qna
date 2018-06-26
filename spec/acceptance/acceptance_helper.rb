require 'rails_helper'

RSpec.configure do |config|
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

  config.use_transactional_fixtures = true

  Capybara.javascript_driver = :selenium_chrome_headless

  Capybara.server = :puma

  ActionDispatch::IntegrationTest
  Capybara.server_port = 3000
  Capybara.app_host = 'http://localhost:3000'
end
