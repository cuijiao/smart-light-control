require_relative '../services/mqtt_publisher'

class Light < ActiveRecord::Base

  def switch_on
    MQTTPublisher.publish chip_id, {'id' => self.chip_port, 'status' => 1}
    self.update!({:status => '1'})
  end

  def switch_off
    MQTTPublisher.publish chip_id, {'id' => self.chip_port, 'status' => 0}
    self.update!({:status => '0'})
  end
end
