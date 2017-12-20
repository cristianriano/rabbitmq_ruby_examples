# frozen_string_literal: true
# encoding: utf-8

require "bunny"

conn = Bunny.new
conn.start

ch  = conn.create_channel
x   = ch.fanout("logs")

# Create a unique queue with random name for this consumer
# It will be destroyed once the consumer is down
q   = ch.queue("", exclusive: true)

q.bind(x)

puts " [*] Waiting for logs. To exit press CTRL+C"

begin
  q.subscribe(block: true) do |delivery_info, properties, body|
    puts " [x] #{body}"
  end
rescue Interrupt => _
  ch.close
  conn.close
end
