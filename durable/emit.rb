# frozen_string_literal: true
# encoding: utf-8

require "bunny"

conn = Bunny.new
conn.start

ch   = conn.create_channel
# Same configuration as the receiver
q    = ch.queue("task_queue", durable: true)

msg  = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

q.publish(msg, persistent: true)
puts " [x] Sent #{msg}"

sleep 1.0
conn.close
