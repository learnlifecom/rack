module Rack
  class Lock
    FLAG = Const::RACK_MULTITHREAD.freeze

    def initialize(app, lock = Mutex.new)
      @app, @lock = app, lock
    end

    def call(env)
      old, env[FLAG] = env[FLAG], false
      @lock.synchronize { @app.call(env) }
    ensure
      env[FLAG] = old
    end
  end
end
