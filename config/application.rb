require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require 'action_cable/engine'
# require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module CrazyEra
  class Application < Rails::Application
    config.load_defaults 5.2
    config.middleware.use Rack::Session::Cookie
    config.api_only                    = true
    config.active_record.primary_key   = :uuid
    config.active_record.schema_format = :sql
    config.time_zone                   = 'Europe/Moscow'
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
