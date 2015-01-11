ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActiveSupport::TestCase
  fixtures :all

  def t(*args)
    I18n.t *args
  end

  def l(*args)
    I18n.l *args
  end
end

class ActionController::TestCase
  def authenticate(guest)
    session[:guest_id] = guest.id
  end
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
