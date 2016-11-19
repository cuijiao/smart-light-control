require 'mqtt'
require 'uri'

class LightController < ApplicationController
  before_action :set_domain

  def index
  end

  def south_index
  end

  def center_index
  end

  def north_index
  end

  def publish_broker
    MQTT::Client.connect(conn_opts) do |c|
      c.publish('ruby', "Hello World #{params['light_num']}")
    end
    render :nothing=>true
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