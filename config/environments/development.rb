require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.cache_classes = false

  config.eager_load = false

  config.consider_all_requests_local = true

  config.server_timing = true

  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.active_storage.service = :amazon

  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  config.action_mailer.delivery_method = :letter_opener_web
  config.action_mailer.default_url_options = Settings.default_url_options.to_h

  config.active_support.deprecation = :log

  config.active_support.disallowed_deprecation = :raise

  config.active_support.disallowed_deprecation_warnings = []

  config.active_record.migration_error = :page_load

  config.active_record.verbose_query_logs = true

  config.assets.quiet = true
  
  # 全てのホストからのアクセスを許可
  config.hosts.clear
end
