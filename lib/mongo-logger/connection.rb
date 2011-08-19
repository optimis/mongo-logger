module MongoLogger
  module Connection
    extend Connection

    def connect
      conn = Mongo::Connection.new(MongoLogger::Config.mongo_connection[:host], MongoLogger::Config.mongo_connection[:port], :auto_reconnect => true)
      db = conn.db MongoLogger::Config.mongo_connection[:database]
      
      unless db.collection_names.include? MongoLogger::Config.collection_name
        db.create_collection(MongoLogger::Config.collection_name, :capped => true, :size => MongoLogger::Config.collection_size)
      end

      db.collection MongoLogger::Config.collection_name
    end
  end
end
