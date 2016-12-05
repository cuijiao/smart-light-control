require 'mqtt'
require 'uri'

class MQTTPublisher

  def self.publish chip_id, message
    uri = URI.parse ENV['CLOUDMQTT_URL']

    conn_opts= {
        remote_host: uri.host,
        remote_port: uri.port,
        username: uri.user,
        password: uri.password,
    }

    MQTT::Client.connect(conn_opts) do |c|
      c.publish("/smart_switch/#{chip_id}", message.to_json)
    end
  end
end