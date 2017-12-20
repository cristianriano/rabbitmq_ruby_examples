# frozen_string_literal: true
# encoding: utf-8

require "bunny"

SEVERITIES = %w(info warning error)

conn = Bunny.new
conn.start

ch       = conn.create_channel
x        = ch.direct("direct_logs")
severity = ARGV.shift || SEVERITIES.first
msg      = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

x.publish(msg, routing_key: severity)
puts " [x] Sent '#{msg}'"

conn.close
