# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'action_cable/engine'
require 'action_cable'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TestApp
  # app test
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.action_cable.mount_path = '/cable'
    config.action_cable.disable_request_forgery_protection = true

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
