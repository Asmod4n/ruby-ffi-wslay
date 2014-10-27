require 'ffi'
require_relative '../event'
require_relative '../enums'

module Wslay
  module Event
    module Context
      extend FFI::Library
      ffi_lib :wslay

      attach_function :server_init, :wslay_event_context_server_init, [:pointer, Callbacks.ptr, :pointer],  Error
      attach_function :client_init, :wslay_event_context_client_init, [:pointer, Callbacks.ptr, :pointer],  Error
      attach_function :free,        :wslay_event_context_free,        [:pointer],                           :void
    end
  end
end
