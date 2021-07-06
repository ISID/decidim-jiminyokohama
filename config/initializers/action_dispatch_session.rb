# frozen_string_literal: true

require "rack/session/abstract/id"

module ActionDispatch
  class Request
    # Session is responsible for lazily loading the session from store.
    class Session # :nodoc:

      # Returns value of the key stored in the session or
      # +nil+ if the given key is not found in the session.
      def [](key)
        load_for_read!
        key = key.to_s


        if key == "session_id"
          begin
            id && id.public_id
          rescue
            id
          end
        else
          @delegate[key]
        end
      end

      
    end
  end
end