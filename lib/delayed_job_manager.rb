require 'singleton'

class DelayedJobManager
  include Singleton

  def initialize
    @delayed_jobs = {}
    Light.all.select(:light_id).each do |light|
      @delayed_jobs["#{light.light_id}"] = []
    end
  end

  def self.get_delayed_jobs_by light_id
    instance.get_delayed_jobs_by(light_id)
  end

  def self.insert_delayed_jobs_for light_id, delayed_job_id
    instance.insert_delayed_jobs_for light_id, delayed_job_id
  end

  def self.reset_delayed_jobs_for light_id
    instance.reset_delayed_jobs_for light_id
  end

  def get_delayed_jobs_by light_id
    @delayed_jobs["#{light_id}"]
  end

  def insert_delayed_jobs_for light_id, delayed_job_id
    @delayed_jobs["#{light_id}"] << delayed_job_id
  end

  def reset_delayed_jobs_for light_id
    @delayed_jobs["#{light_id}"] = []
  end
end
