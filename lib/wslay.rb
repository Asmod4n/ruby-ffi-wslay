require 'ffi'

module Wslay
  WS_GUID = '258EAFA5-E914-47DA-95CA-C5AB0DC85B11'.freeze
  module_function

  def is_ctrl_frame(opcode)
    ((opcode >> 3) & 1) == 1
  end

  def get_rsv1(rsv)
    ((rsv >> 2) & 1) == 1
  end

  def get_rsv2(rsv)
    ((rsv >> 1) & 1) == 1
  end

  def get_rsv3(rsv)
    (rsv & 1) == 1
  end
end

require_relative 'wslay/enums'
require_relative 'wslay/event'
