require 'mqtt'
require 'uri'

class LightController < ApplicationController

  def index
  end

  def publish_broker
    MQTT::Client.connect(conn_opts) do |c|
      c.publish('ruby', "Hello World #{params['light_num']}")
    end
    render :index
  end

  private

  def conn_opts
    uri = URI.parse ENV['CLOUDMQTT_URL']
    {
        remote_host: uri.host,
        remote_port: uri.port,
        username: uri.user,
        password: uri.password,
    }
  end
end