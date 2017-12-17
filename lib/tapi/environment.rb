class Environment
  attr_reader :envs

  def initialize
    @envs = {}
    environment :default
    @current_scope = :default
  end

  def init
    instance_eval(File.read("env.rb"), "env.rb")
  end

  def scheme(scheme)
    envs[@current_scope][:scheme] = scheme
  end

  def base(base)
    envs[@current_scope][:base] = base
  end

  def host(host)
    envs[@current_scope][:host] = host
  end

  def current_env
    @envs[:default].merge(@envs[:dev])
  end

  def base_url
    "#{current_env[:scheme]}://#{current_env[:host]}#{current_env[:base]}"
  end

  def environment(env, &block)
    envs[env] ||= {}
    if block_given?
      @current_scope = env
      yield block
      @current_scope = :default
    end
  end
end
