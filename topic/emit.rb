# frozen_string_literal: true
# encoding: utf-8

require "bunny"

conn = Bunny.new
conn.start

ch       = conn.create_channel
x        = ch.topic("topic_logs")
severity = ARGV.shift || "anonymous.info"
msg      = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

x.publish(msg, routing_key: severity)
puts " [x] Sent '#{msg}'"

conn.close
