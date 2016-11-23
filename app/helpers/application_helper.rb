module ApplicationHelper
  def on? light
    light.status == 1
  end
end
