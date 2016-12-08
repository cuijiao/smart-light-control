class WebsocketEventController < WebsocketRails::BaseController
  def client_connected
    p 'client connected'
  end

  def switch_on
    p 'switch on'
    switch_light data[:light_id], 'on'
    broadcast_message :switch_on_success, data, :namespace => :light
  end

  def switch_off
    p 'switch off'
    switch_light data[:light_id], 'off'
    broadcast_message :switch_off_success, data, :namespace => :light
  end

  def section_switch_on
    lights = Light.where('section = ?', data[:section])
    lights.each do |light|
      switch_light light.light_id, 'on'
      broadcast_message :switch_on_success, {'light_id' => light.light_id }, :namespace => :light
    end
  end

  def section_switch_off
    lights = Light.where('section = ?', data[:section])
    lights.each do |light|
      switch_light light.light_id, 'off'
      broadcast_message :switch_off_success, {'light_id' => light.light_id }, :namespace => :light
    end
  end

  private

  def switch_light light_id, status
    lights = Light.where('light_id = ?', light_id)

    lights.each do |light|
      if need_delay? && status == 'off'
        light.switch_off
        broadcast_message :switch_off_success, {'light_id' => light.light_id }, :namespace => :light
        light.delay(run_at: 5.seconds.from_now).switch_on
        light.delay(run_at: 60.seconds.from_now).switch_off
      else
        status == 'on' ? light.switch_on : light.switch_off
      end
    end
  end

  def need_delay?
    (Time.now.utc.hour+8) % 24 > delay_threshold
  end

  def delay_threshold
    ENV['DELAY_THRESHOLD'].blank? ? 21 : ENV['DELAY_THRESHOLD'].to_i
  end
end