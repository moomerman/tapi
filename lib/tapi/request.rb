class Request
  attr_reader :name, :method, :gbody, :gstatus, :gschema, :schema_name

  def initialize(name, method)
    @name = name
    @method = method
  end

  def body(body)
    @gbody = body
  end

  def status(status)
    @gstatus = status
  end

  # definition can be a symbol reference or a hash
  def schema(schema)
    if schema.is_a? Symbol
      @schema_name = schema
      @gschema = Schema.get(schema)
    else
      @gschema = schema
    end
  end

  def execute(url, request_schema)
    print "  #{method.downcase} [#{brown(name)}] => "
    res = begin
      RestClient::Request.execute(
        method: method,
        url: url,
        payload: gbody.to_json,
        headers: {"Content-Type": "application/json"},
        verify_ssl: false
      ).tap do |res|
      end
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end

    warn = []
    err = []

    # validate request
    errors = Schema.validate(request_schema, gbody)
    errors.each do |error|
      warn << blue("    !> #{clean_validation_error(error)}")
    end

    # check response code
    unless res.code == gstatus.code
      err << red("    => #{clean_response_body(res.body)}")
      err << red("    !! expected #{gstatus.code} got #{res.code}")
    end

    # validate response
    errors = Schema.validate(gschema, res.body)
    errors.each do |error|
      err << cyan("    !< #{clean_validation_error(error)}")
    end

    puts err.empty? ? green(res.code) : red(res.code)
    err.each{|e| puts e}
    warn.each{|e| puts e}
  end

  private
    def clean_validation_error(error)
      error.gsub!("The property ", "")
      error.gsub!("did not contain a required property of", "required")
      error.gsub!(" outside of the schema when none are allowed", "")
      error.gsub!("contains additional properties", "additional")
      error
    end

    def clean_response_body(body)
      body.strip!
      return "<empty body>" if body == ""
      body
    end

    def red(s); "\e[31m#{s}\e[0m" end
    def green(s); "\e[32m#{s}\e[0m" end
    def brown(s); "\e[33m#{s}\e[0m" end
    def blue(s); "\e[34m#{s}\e[0m" end
    def cyan(s); "\e[36m#{s}\e[0m" end
    def gray(s); "\e[37m#{s}\e[0m" end

end
