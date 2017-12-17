module HTTP
  class OK
    def self.code
      200
    end
  end

  class Created
    def self.code
      201
    end
  end

  class BadRequest
    def self.code
      400
    end
  end

  class Forbidden
    def self.code
      403
    end
  end
end
