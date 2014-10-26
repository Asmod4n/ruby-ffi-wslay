﻿require 'ffi'
require_relative 'enums'

module Wslay
  module Event
    extend FFI::Library
    ffi_lib :wslay

    class OnMsgRecvArg < FFI::Struct
      layout  :rsv,         :uint8,
              :opcode,      OpCode,
              :msg,         :pointer,
              :msg_length,  :size_t,
              :status_code, StatusCode
    end

    class OnFrameRecvStartArg < FFI::Struct
      layout  :fin,             :uint8,
              :rsv,             :uint8,
              :opcode,          OpCode,
              :payload_length,  :uint64
    end

    class OnFrameRecvChunkArg < FFI::Struct
      layout  :data,        :pointer,
              :data_length, :size_t
    end

    class Callbacks < FFI::Struct
      layout  :recv_callback,                 :pointer,
              :send_callback,                 :pointer,
              :genmask_callback,              :pointer,
              :on_frame_recv_start_callback,  :pointer,
              :on_frame_recv_chunk_callback,  :pointer,
              :on_frame_recv_end_callback,    :pointer,
              :on_msg_recv_callback,          :pointer
    end

    class Msg < FFI::Struct
      layout  :opcode,      OpCode,
              :msg,         :pointer,
              :msg_length,  :size_t
    end

    attach_function :context_server_init, :wslay_event_context_server_init, [:pointer, Callbacks.ptr, :pointer],  Error
    attach_function :context_client_init, :wslay_event_context_client_init, [:pointer, Callbacks.ptr, :pointer],  Error
    attach_function :context_free,        :wslay_event_context_free,        [:pointer],                           :void

    attach_function :read,  :wslay_event_recv,  [:pointer], Error
    attach_function :write, :wslay_event_send,  [:pointer], Error

    attach_function :queue_msg,   :wslay_event_queue_msg,   [:pointer, Msg.ptr],  Error
    attach_function :queue_close, :wslay_event_queue_close, [:pointer, StatusCode, :buffer_in, :size_t],  Error

    attach_function :set_error, :wslay_event_set_error, [:pointer, Error],  :void

    attach_function :want_read,   :wslay_event_want_read,   [:pointer], :bool
    attach_function :want_write,  :wslay_event_want_write,  [:pointer], :bool

    attach_function :get_close_received,        :wslay_event_get_close_received,        [:pointer], :bool
    attach_function :get_close_sent,            :wslay_event_get_close_sent,            [:pointer], :bool
    attach_function :get_status_code_received,  :wslay_event_get_status_code_received,  [:pointer], StatusCode
    attach_function :get_status_code_sent,      :wslay_event_get_status_code_sent,      [:pointer], StatusCode
    attach_function :get_queued_msg_count,      :wslay_event_get_queued_msg_count,      [:pointer], :size_t
    attach_function :get_queued_msg_length,     :wslay_event_get_queued_msg_length,     [:pointer], :size_t
  end
end