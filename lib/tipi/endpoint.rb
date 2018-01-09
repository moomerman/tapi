class Endpoint
  attr_reader :path, :description, :examples, :gschema, :schema_name

  def initialize(path)
    @path = path
    @examples = []
    @current_method = nil
  end

  def desc(desc)
    @description = desc
  end

  def post(&block)
    @current_method = :post
    instance_eval(&block)
  end

  # schema can be a symbol reference or a hash
  def schema(schema)
    if schema.is_a? Symbol
      @schema_name = schema
      @gschema = Schema.get(schema)
    else
      @gschema = schema
    end
  end

  def example(name, &block)
    examples << Request.new(name, @current_method).tap{|x| x.instance_eval(&block)}
  end

  def execute(base_url)
    puts path
    examples.each do |example|
      example.execute(base_url + path, gschema).inspect
    end
  end

end
