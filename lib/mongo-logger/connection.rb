module MongoLogger
  module Connection
    extend Connection

    def connect
      if MongoLogger::Config.respond_to?(:stubbed?) && MongoLogger::Config.stubbed?
        stubbed_collection
      else
        mongo_collection
      end
    end

    def mongo_collection
      conn = Mongo::Connection.new(MongoLogger::Config.mongo_connection[:host], MongoLogger::Config.mongo_connection[:port], :auto_reconnect => true)
      db = conn.db MongoLogger::Config.mongo_connection[:database]
      
      unless db.collection_names.include? MongoLogger::Config.collection_name
        db.create_collection(MongoLogger::Config.collection_name, :capped => true, :size => MongoLogger::Config.collection_size)
      end

      db.collection MongoLogger::Config.collection_name
    end

    def stubbed_collection
      Class.new do
        def self.insert *args

        end
      end
    end
  end
end
