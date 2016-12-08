require 'mqtt'
require 'uri'

class LightController < ApplicationController
  before_action :set_domain

  def index
    @location = 'home'
    @south_master_control_toggle_on = Light.exists?(:status => 1, :section => 'south')
    @center_master_control_toggle_on = Light.exists?(:status => 1, :section => 'center')
    @north_master_control_toggle_on = Light.exists?(:status => 1, :section => 'north')
  end

  def south_index
    @location = 'south'
    @light1 = Light.where('light_id = 1').first
    @light2 = Light.where('light_id = 2').first
    @light3 = Light.where('light_id = 3').first
    @light4 = Light.where('light_id = 4').first
  end

  def center_index
    @location = 'center'
    @light1 = Light.where('light_id = 5').first
    @light2 = Light.where('light_id = 6').first
    @light3 = Light.where('light_id = 7').first
    @light4 = Light.where('light_id = 8').first
  end

  def north_index
    @location = 'north'
    @light1 = Light.where('light_id = 9').first
    @light2 = Light.where('light_id = 10').first
    @light3 = Light.where('light_id = 11').first
    @light4 = Light.where('light_id = 12').first
  end

  def publish_broker
    section, light_id, status = params['section'], params['light_id'], params['status'].to_i
    light_id.nil? ? switch_section(section, status) : switch_light(section, light_id, status)
    render :nothing => true
  end

  private

  def switch_section section, status
    lights = Light.where('section = ?', section)

    lights.each do |light|
      if need_delay? && status == 0
        light.delay_switch_off
      else
        status == 1 ? light.switch_on : light.switch_off
      end
    end
  end

  def switch_light section, light_id, status
    lights = Light.where('section = ? and light_id = ?', section, light_id)

    lights.each do |light|
      if need_delay? && status == 0
        light.delay_switch_off
      else
        status == 1 ? light.switch_on : light.switch_off
      end
    end
  end

  def need_delay?
    Time.now.utc.hour+8 > ENV['DELAY_THRESHOLD'].to_i
  end
end