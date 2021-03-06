logger RBSavvy.logger

worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout Integer(ENV["TIMEOUT"] || 15)
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    RBSavvy.logger.info 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    RBSavvy.logger.info 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
end
