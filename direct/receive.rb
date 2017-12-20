# frozen_string_literal: true
# encoding: utf-8

require "bunny"
require "pry"

SEVERITIES = %w(info warning error)

if ARGV.empty?
  abort "Usage: #{$0} #{SEVERITIES.map{|s| "[#{s}]"}.join(" ")}"
end

conn = Bunny.new
conn.start

ch  = conn.create_channel
# Direct exchange
x   = ch.direct("direct_logs")
q   = ch.queue("", exclusive: true)

ARGV.select{|arg| SEVERITIES.include? arg}.each do |severity|
  # Register the queue with each of the binding keys (log severities)
  q.bind(x, routing_key: severity)
end

puts " [*] Waiting for logs. To exit press CTRL+C"

begin
  q.subscribe(block: true) do |delivery_info, properties, body|
    puts " [x] #{delivery_info.routing_key}: #{body}"
  end
rescue Interrupt => _
  ch.close
  conn.close
  exit(0)
end
