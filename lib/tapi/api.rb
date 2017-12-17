module Tapi
  class API
    attr_reader :env, :version, :title, :description, :endpoints

    def initialize(env)
      @env = env
      @endpoints = []
    end

    def init
      Dir.glob("api/*.rb").each do |file|
        instance_eval(File.read(file), file)
      end
    end

    def v(v)
      @version = v
    end

    def desc(desc)
      @description = desc
    end

    def name(name)
      @title = name
    end

    def endpoint(path, &block)
      @endpoints << Endpoint.new(path).tap{|x| x.instance_eval &block}
    end

    def execute_tests
      @endpoints.each do |endpoint|
        endpoint.execute(env.base_url)
      end
    end

    def generate_spec
      generator = Spec::OpenAPI.new(self)
      generator.generate
    end

    def self.boot()
      e = Environment.new
      e.init
      # e.envs.each{|x| puts x.inspect}

      s = Schema.init
      # s.schemas.each{|x| puts x.inspect}

      API.new(e).tap do |api|
        api.init
      end
    end
  end

end
