require 'mqtt'
require 'uri'

class LightController < ApplicationController
  before_action :set_domain

  def index
    @south_master_control_toggle_on = Light.exists?(:status =>1, :section => 'south')
    @center_master_control_toggle_on = Light.exists?(:status =>1, :section => 'center')
    @north_master_control_toggle_on = Light.exists?(:status =>1, :section => 'north')
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
    section, light_id, status = params['section'], params['light_id'], params['status'].to_i
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
    chip_details = Light.where('section = ?', section).select('chip_id, chip_port')

    chip_details.each do |chip_detail|
      publish_message_to_broker chip_detail.chip_id, chip_detail.chip_port, status
    end

    Light.where('section = ?', section).update_all("status = '#{status}'")
  end

  def switch_light section, light_id, status
    chip_details = Light.where('section = ? and light_id = ?', section, light_id).select('chip_id, chip_port')

    chip_details.each do |chip_detail|
      publish_message_to_broker chip_detail.chip_id, chip_detail.chip_port, status
    end

    Light.where("section = '#{section}' and light_id = #{light_id}").update_all("status = '#{status}'")
  end

  def publish_message_to_broker chip_id, chip_port, status
    MQTT::Client.connect(conn_opts) do |c|
      c.publish("/smart_switch/#{chip_id}", {'id' => chip_port, 'status' => status}.to_json)
    end
  end
end