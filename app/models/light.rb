require_relative '../services/mqtt_publisher'

class Light < ActiveRecord::Base

  def call
  end

  def switch_on
    MQTTPublisher.publish chip_id, {'id' => self.chip_port, 'status' => 1}
    self.update!({:status => '1'})
  end

  def switch_off
    MQTTPublisher.publish chip_id, {'id' => self.chip_port, 'status' => 0}
    self.update!({:status => '0'})
  end

  def delay_switch_off
    switch_off
    self.delay(run_at: 5.seconds.from_now).switch_on
    self.delay(run_at: 15.seconds.from_now).switch_off
  end
end
