module MongoLogger
  module Config
    def self.mongo_connection
      { :host => 'localhost', :database => 'mongo_logger_gem_test' }
    end

    def self.collection_size
      536870912 #512MB
    end

    def self.severity
      :warn
    end
  end
end
