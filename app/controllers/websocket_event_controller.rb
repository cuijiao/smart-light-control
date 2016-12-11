class WebsocketEventController < WebsocketRails::BaseController
  def client_connected
    p 'client connected'
  end

  def switch_on
    switch_light data[:light_id], 'on', :switch_on_success
  end

  def switch_off
    switch_light data[:light_id], 'off', :switch_off_success
  end

  def check_delay
    p 'check_delay'
    light = Light.where('light_id = ?', data[:light_id])[0]
    if light.status == 1
      broadcast_message :switch_on_success, data, :namespace => :light
    else
      broadcast_message :switch_off_success, data, :namespace => :light
    end
  end

  def section_switch_on
    lights = Light.where('section = ?', data[:section])
    lights.each do |light|
      switch_light light.light_id, 'on', :switch_on_success
    end
  end

  def section_switch_off
    lights = Light.where('section = ?', data[:section])
    lights.each do |light|
      switch_light light.light_id, 'off', :switch_off_success
    end
  end

  private

  def switch_light light_id, status, callback
    light = Light.where('light_id = ?', light_id)[0]

    if need_delay? && status == 'off'
      light.switch_off
      light.delay(run_at: 3.seconds.from_now).switch_on
      broadcast_message :delay_switch_off, {'light_id' => light_id}, :namespace => :light
      light.delay(run_at: 10.seconds.from_now).switch_off
    else
      status == 'on' ? light.switch_on : light.switch_off
      broadcast_message callback, {'light_id' => light_id}, :namespace => :light
    end
  end

  def need_delay?
    Time.now.utc.hour+8 > delay_threshold
  end

  def delay_threshold
    ENV['DELAY_THRESHOLD'].blank? ? 21 : ENV['DELAY_THRESHOLD'].to_i
  end
end