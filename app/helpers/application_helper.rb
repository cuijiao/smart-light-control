module ApplicationHelper
  def on? light
    light.status == 'on'
  end
end
