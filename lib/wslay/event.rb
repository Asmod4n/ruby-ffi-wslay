require 'ffi'
require_relative 'enums'

module Wslay
  module Event
    extend FFI::Library
    ffi_lib :wslay

    class OnMsgRecvArg < FFI::Struct
      layout  :rsv,         :uint8,
              :opcode,      :uint8,
              :msg,         :pointer,
              :msg_length,  :size_t,
              :status_code, :uint16
    end

    class OnFrameRecvStartArg < FFI::Struct
      layout  :fin,             :uint8,
              :rsv,             :uint8,
              :opcode,          :uint8,
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

      def recv_callback(&block)
        self[:recv_callback] = FFI::Function.new(:ssize_t, [:pointer, :pointer, :size_t, :int, :pointer], blocking: true) do |ctx, buf, len, flags, user_data|
          yield(ctx, buf, len, flags)
        end
      end

      def send_callback(&block)
        self[:send_callback] = FFI::Function.new(:ssize_t, [:pointer, :pointer, :size_t, :int, :pointer], blocking: true) do |ctx, data, len, flags, user_data|
          yield(ctx, data, len, flags)
        end
      end

      def genmask_callback(&block)
        self[:genmask_callback] = FFI::Function.new(:int, [:pointer, :pointer, :size_t, :pointer], blocking: true) do |ctx, buf, len, user_data|
          yield(ctx, buf, len)
        end
      end

      def on_msg_recv_callback(&block)
        self[:on_msg_recv_callback] = FFI::Function.new(:void, [:pointer, OnMsgRecvArg.ptr, :pointer], blocking: true) do |ctx, arg, user_data|
          yield(ctx, arg)
        end
      end
    end

    class Msg < FFI::Struct
      layout  :opcode,      :uint8,
              :msg,         :pointer,
              :msg_length,  :size_t
    end

    attach_function :read,  :wslay_event_recv,  [:pointer], Error, blocking: true
    attach_function :write, :wslay_event_send,  [:pointer], Error, blocking: true

    attach_function :queue_msg,   :wslay_event_queue_msg,   [:pointer, Msg.ptr],  Error, blocking: true
    attach_function :queue_close, :wslay_event_queue_close, [:pointer, StatusCode, :buffer_in, :size_t],  Error, blocking: true

    attach_function :set_error, :wslay_event_set_error, [:pointer, Error],  :void, blocking: true

    attach_function :want_read,   :wslay_event_want_read,   [:pointer], :bool, blocking: true
    attach_function :want_write,  :wslay_event_want_write,  [:pointer], :bool, blocking: true

    attach_function :get_close_received,        :wslay_event_get_close_received,        [:pointer], :bool, blocking: true
    attach_function :get_close_sent,            :wslay_event_get_close_sent,            [:pointer], :bool, blocking: true
    attach_function :get_status_code_received,  :wslay_event_get_status_code_received,  [:pointer], StatusCode, blocking: true
    attach_function :get_status_code_sent,      :wslay_event_get_status_code_sent,      [:pointer], StatusCode, blocking: true
    attach_function :get_queued_msg_count,      :wslay_event_get_queued_msg_count,      [:pointer], :size_t, blocking: true
    attach_function :get_queued_msg_length,     :wslay_event_get_queued_msg_length,     [:pointer], :size_t, blocking: true
  end
end
