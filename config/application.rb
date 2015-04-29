require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Archextract
  class Application < Rails::Application
    config.active_job.queue_adapter = :delayed_job
    config.jobs = ActiveSupport::OrderedOptions.new
    # Controls whether or not workers report heartbeats
    config.jobs.heartbeat_enabled = true
    # How often workers should send heartbeats
    config.jobs.heartbeat_interval_seconds = 60
    # How long a worker can go without sending a heartbeat before they're considered dead
    config.jobs.heartbeat_timeout_seconds = 3 * 60
    # How often to check for dead workers
    config.jobs.dead_worker_polling_interval_seconds = 60
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
