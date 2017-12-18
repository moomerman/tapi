class Schema

  def self.init
    @schemas = {}
    Dir.glob("schema/*.rb").each do |file|
      instance_eval(File.read(file), file)
    end
  end

  def self.schema(name, definition)
    definition[:id] ||= name # The referenced schemas MUST have an ID
    definition[:additionalProperties] = false

    unless Schema.validate_schema(name, definition)
      puts "[WARN] schema #{name} is not valid"
    end

    @schemas[name] = JSON.parse(definition.to_json)
  end

  def self.schemas
    @schemas
  end

  def self.get(name)
    @schemas[name]
  end

  def self.read(uri)
    name = uri.to_s.split("/").last.to_sym
    JSON::Schema.new(get(name), uri).tap do |schema|
      JSON::Validator.add_schema(schema)
    end
  end

  def self.validate(schema, document)
    JSON::Validator.fully_validate(schema, document,
      validate_schema: true, strict: false, schema_reader: self
    )
  end

  def self.validate_schema(name, schema)
    metaschema = JSON::Validator.validator_for_name("draft4").metaschema
    JSON::Validator.validate(metaschema, schema)
  end

end
