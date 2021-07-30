Rails.application.config.session_store :active_record_store, key: "_sample_session", expire_after: 1.day, secure: Rails.env.production?, domain: Rails.env.production? ? ENV['DOMAIN'] : :all