require 'ffi'
require_relative '../event'

module Wslay
  module Event
    module Config
      extend FFI::Library
      ffi_lib :wslay

      attach_function :set_no_buffering,        :wslay_event_config_set_no_buffering,         [:pointer, :bool],          :void
      attach_function :set_max_recv_msg_length, :wslay_event_config_set_max_recv_msg_length,  [:pointer, :uint64],        :void
      attach_function :set_callbacks,           :wslay_event_config_set_callbacks,            [:pointer, Callbacks.ptr],  :void
    end
  end
end
