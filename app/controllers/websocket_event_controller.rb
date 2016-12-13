require 'delayed_job_manager'

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

  def section_switch_on
    lights = Light.where('section = ?', data[:section])
    lights.each do |light|
      light.switch_on
      broadcast_message :switch_on_success, {'light_id' => light.light_id}, :namespace => :light
    end
  end

  def section_switch_off
    lights = Light.where('section = ?', data[:section])
    lights.each do |light|
      light.switch_off
      broadcast_message :switch_off_success, {'light_id' => light.light_id}, :namespace => :light
    end
  end

  def check_delay
    light = Light.where('light_id = ?', data[:light_id])[0]
    light.status == 1 ? broadcast_message(:switch_on_success, data, :namespace => :light) : broadcast_message(:switch_off_success, data, :namespace => :light)
  end

  def cancle_delay
    light_id = data[:light_id]
    ids = DelayedJobManager.get_delayed_jobs_by light_id
    Delayed::Job.where('id in (?)', ids).delete_all
    DelayedJobManager.reset_delayed_jobs_for light_id
  end

  private

  def switch_light light_id, status, callback
    light = Light.where('light_id = ?', light_id)[0]

    if need_delay? && status == 'off'
      light.switch_off
      light.delay(run_at: 1.seconds.from_now).switch_on
      broadcast_message :delay_switch_off, {'light_id' => light_id}, :namespace => :light
      job = light.delay(run_at: 63.seconds.from_now).switch_off
      DelayedJobManager.insert_delayed_jobs_for light_id, job.id
    else
      status == 'on' ? light.switch_on : light.switch_off
      broadcast_message callback, {'light_id' => light_id}, :namespace => :light
    end
  end

  def need_delay?
    (Time.now.utc.hour+8)%24 > delay_threshold
  end

  def delay_threshold
    ENV['DELAY_THRESHOLD'].blank? ? 21 : ENV['DELAY_THRESHOLD'].to_i
  end
end