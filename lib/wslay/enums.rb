require 'ffi'

module Wslay
  extend FFI::Library

  Error = enum  [ :want_read,         -100,
                  :want_write,        -101,
                  :proto,             -200,
                  :invalid_argument,  -300,
                  :invalid_callback,  -301,
                  :no_more_msg,       -302,
                  :callback_failure,  -400,
                  :would_block,       -401,
                  :nomem,             -500]

  StatusCode = enum [ :normal_closure,              1000,
                      :going_away,
                      :protocol_error,
                      :unsupported_data,
                      :no_status_rcvd,              1005,
                      :abnormal_closure,
                      :invalid_frame_payload_data,
                      :policy_violation,
                      :message_too_big,
                      :mandatory_ext,
                      :internal_server_error,
                      :tls_handshake,               1015]

  IoFlags = enum  [:msg_more, 1]

  OpCode = enum [ :continuation_frame,  0x0,
                  :text_frame,          0x1,
                  :binary_frame,        0x2,
                  :connection_close,    0x8,
                  :ping,                0x9,
                  :pong,                0xa]
end
