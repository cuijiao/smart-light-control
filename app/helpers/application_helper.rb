require 'delayed_job_manager'

module ApplicationHelper
  def on? status
    status == 1 || status == true
  end

  def delay? light_id
    !DelayedJobManager.get_delayed_jobs_by(light_id).empty?
  end
end
