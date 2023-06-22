# config/initializers/delayed_job.rb

Rails.application.config.after_initialize do
    Delayed::Job.enqueue(CleanupTaskJob.new, run_at: Time.current)
end
  