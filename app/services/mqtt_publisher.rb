require 'mqtt'
require 'uri'

class MQTTPublisher

  def self.publish chip_id, message
    conn_opts= {
        remote_host: 'm13.cloudmqtt.com',
        remote_port: '13920',
        username: 'smart_switch',
        password: 'smart_switch',
    }

    MQTT::Client.connect(conn_opts) do |c|
      c.publish("/smart_switch/#{chip_id}", message.to_json)
    end
  end
end