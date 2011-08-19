require 'spec_helper'

describe MongoLogger::Connection do

  after do
    MongoLogger.mongo_collection.remove if MongoLogger.mongo_collection.respond_to? :remove
  end
  describe '.connect' do
    it 'should open the connection to mongo' do
      MongoLogger.mongo_collection.name.should == MongoLogger::Config.collection_name
      MongoLogger.mongo_collection.db.name.should == MongoLogger::Config.mongo_connection[:database]
      MongoLogger.mongo_collection.db.connection.primary[0].should == MongoLogger::Config.mongo_connection[:host]
      MongoLogger.mongo_collection.db.connection.primary[1].should == 27017
    end

    it 'should open connection to mongo when gem is loaded' do
      MongoLogger.mongo_collection.should be_instance_of Mongo::Collection
    end

    it 'should create the capped collection if it does not exist' do
      MongoLogger.mongo_collection.stats['capped'].should == 1
    end
  end
end
