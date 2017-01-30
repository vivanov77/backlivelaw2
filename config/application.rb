require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Backlivelaw2
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

# http://stackoverflow.com/questions/4110866/ruby-on-rails-where-to-define-global-constants
    config.roles = {client:"Клиент", admin:"Администратор", lawyer:"Юрист", advocate:"Адвокат"}

  end
end
