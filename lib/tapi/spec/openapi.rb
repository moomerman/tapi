module Spec
  class OpenAPI
    attr_reader :api

    def initialize(api)
      @api = api
    end

    def generate
      spec =<<-EOF
openapi: 3.0.0
info:
  version: #{api.version}
  title: #{api.title}
  description: #{api.description}
servers:
  - url: #{api.env.base_url}
      EOF

      spec << "paths:\n"
      api.endpoints.each do |endpoint|
        spec << "  #{endpoint.path}:\n"
        spec << "    #{endpoint.examples.first.method.downcase}:\n"
        spec << "      description: #{endpoint.description}\n"

        unless endpoint.gschema.nil?
          spec << "      requestBody:\n"
          spec << "        description: TODO\n"
          spec << "        required: true\n"
          spec << "        content:\n"
          spec << "          application/json:\n"
          spec << "            schema:\n"
          spec << "              $ref: '#/components/schemas/#{endpoint.schema_name}'\n"
        end

        spec << "      responses:\n"
        endpoint.examples.group_by{|x| x.gstatus}.each do |status, examples|
          spec << "        #{status.code}:\n"
          spec << "          description: #{examples.first.name}\n"
          spec << "          content:\n"
          spec << "            application/json:\n"
          spec << "              schema:\n"
          spec << "                $ref: '#/components/schemas/#{examples.first.schema_name}'\n"
        end
      end

      spec << "components:\n"
      spec << "  schemas:\n"
      Schema.schemas.each do |name, schema|
        spec << "    #{name}:\n"
        spec << "      required: #{schema['required'].map(&:to_s)}\n"
        spec << "      properties:\n"
        schema['properties'].each do |name, hash|
          spec << "        #{name}:\n"
          hash.each do |key, value|
            value = "'#/components/schemas/#{value}'" if key == "$ref"
            spec << "          #{key}: #{value}\n"
            # TODO: fix refs!
          end
        end
      end

      # puts spec
      puts YAML.load(spec).to_yaml
    end

  end
end
