require "amqp-client"

module Cable
  class AMQPBackend < Cable::BackendCore
    VERSION = "0.1.0"

    register "amqp"
    register "amqps"

    # connection management
    getter qp_subscribe : AMQP::Client = AMQP::Client.new(Cable.settings.url).connect
    getter qp_publish : AMQP::Client = AMQP::Client.new(Cable.settings.url).connect

    # connection management
    def subscribe_connection : AMQP::Client
      qp_subscribe
    end

    def publish_connection : AMQP::Client
      qp_publish
    end

    def close_subscribe_connection
      qp_subscribe.close
    end

    def close_publish_connection
      qp_publish.close
    end

    # internal pub/sub
    def open_subscribe_connection(channel)
      qp_subscribe.queue
    end

    # external pub/sub
    def publish_message(stream_identifier : String, message : String)
      qp_publish.channel do |ch|
        ch.exchange("chatters", type: "fanout").publish(message)
      end
    end

    # channel management
    def subscribe(stream_identifier : String)
      qp_subscribe.bind(exchange: stream_identifier, routing_key: "")
      qp_subscribe.subscribe(no_ack: false, block: true) do |msg|
        message = msg.body_io.to_s
        if message == "ping"
          Cable::Logger.debug { "Cable::Server#subscribe -> PONG" }
        elsif message == "debug"
          Cable.server.debug
        else
          msg.ack
          # Cable.server.fiber_channel.send({sub_channel, message})
          Cable::Logger.debug { "Cable::Server#subscribe channel:TODO message:#{message}" }
        end
      end
    end

    def unsubscribe(stream_identifier : String)
      qp_subscribe.unsubscribe(stream_identifier)
    end

    # ping/pong
    def ping_subscribe_connection
      Cable.server.publish(Cable::INTERNAL[:channel], "ping")
    end

    def ping_publish_connection
      result = "???"
      Cable::Logger.debug { "Cable::BackendPinger.ping_publish_connection -> #{result}" }
    end
  end
end
