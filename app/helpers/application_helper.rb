module ApplicationHelper
  def on? status
    status == 1 || status == true
  end
end
