WebsocketRails::EventMap.describe do
  subscribe :client_connected, :to => WebsocketEventController, :with_method => :client_connected
  namespace :light do
    subscribe :switch_on, :to => WebsocketEventController, :with_method => :switch_on
    subscribe :switch_off, :to => WebsocketEventController, :with_method => :switch_off
    subscribe :section_switch_on, :to => WebsocketEventController, :with_method => :section_switch_on
    subscribe :section_switch_off, :to => WebsocketEventController, :with_method => :section_switch_off
    subscribe :check_delay, :to => WebsocketEventController, :with_method => :check_delay
    subscribe :cancle_delay, :to => WebsocketEventController, :with_method => :cancle_delay
  end
end
