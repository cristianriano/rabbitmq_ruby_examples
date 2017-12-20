# frozen_string_literal: true
# encoding: utf-8

require "bunny"

conn = Bunny.new
conn.start

ch   = conn.create_channel
# The queue is never lose even if the consumer dies
q    = ch.queue("task_queue", durable: true)

# Set how many messages send at the same time
ch.prefetch(1)
puts " [*] Waiting for messages. To exit press CTRL+C"

begin
  # Have to ACK the message manually, otherwise the message will be enqueued again
  q.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
    puts " [x] Received '#{body}'"
    # Emulate some heavy work
    sleep body.count(".").to_i
    puts " [x] Done"
    # Acknowledge the message
    ch.ack(delivery_info.delivery_tag)
  end
rescue Interrupt => _
  conn.close
end
