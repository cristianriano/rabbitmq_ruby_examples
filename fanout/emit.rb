# frozen_string_literal: true
# encoding: utf-8

require "bunny"

conn = Bunny.new
conn.start

ch   = conn.create_channel
# This will create a fanout exchange (send to all binded queues)
x    = ch.fanout("logs")

msg  = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

x.publish(msg)
puts " [x] Sent #{msg}"

conn.close
