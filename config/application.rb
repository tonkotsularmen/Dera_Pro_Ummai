require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DeraProUmmai
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.i18n.default_locale = :ja # デフォルトの言語を日本語に設定
    # config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}').to_s]
     # 本来であれば上の1行が必須らしいのだが、現在の状況でも日本語化できている。
    config.time_zone = 'Tokyo' # タイムゾーンを東京に設定
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
