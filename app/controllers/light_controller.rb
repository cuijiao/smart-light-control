require 'mqtt'
require 'uri'

class LightController < ApplicationController
  before_action :set_domain

  def index
  end

  def south_index
    @light1 = Light.where("section = 'south' and light_id = 1").first
    @light2 = Light.where("section = 'south' and light_id = 2").first
    @light3 = Light.where("section = 'south' and light_id = 3").first
    @light4 = Light.where("section = 'south' and light_id = 4").first
  end

  def center_index
    @light1 = Light.where("section = 'center' and light_id = 1").first
    @light2 = Light.where("section = 'center' and light_id = 2").first
    @light3 = Light.where("section = 'center' and light_id = 3").first
    @light4 = Light.where("section = 'center' and light_id = 4").first
  end

  def north_index
    @light1 = Light.where("section = 'north' and light_id = 1").first
    @light2 = Light.where("section = 'north' and light_id = 2").first
    @light3 = Light.where("section = 'north' and light_id = 3").first
    @light4 = Light.where("section = 'north' and light_id = 4").first
  end

  def publish_broker
    section, light_id, status = params['section'], params['light_id'], params['status']
    light_id.nil? ? switch_section(section, status) : switch_light(section, light_id, status)
    render :nothing => true
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

  def switch_section section, status
    section_light_ids = Light.where('section = ?', section).map(&:light_id)
    switch_message = section_light_ids.map do |light_id|
      {'section': section, 'id': light_id, 'status': status}
    end

    publish_message switch_message

    Light.where('section = ?', section).update_all("status = '#{status}'")
  end

  def switch_light section, light_id, status
    switch_message = {'section': section, 'id': light_id, 'status': status}

    publish_message switch_message

    Light.where("section = '#{section}' and light_id = #{light_id}").update_all("status = '#{status}'")
  end

  def publish_message message
    MQTT::Client.connect(conn_opts) do |c|
      c.publish('ruby', {'control' => message})
    end
  end
end