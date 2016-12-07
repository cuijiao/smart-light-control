Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_run_time = 15.minutes
Delayed::Worker.sleep_delay = 5
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))