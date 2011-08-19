require 'spec_helper'

describe MongoLogger do
  it 'should log a message' do
    MongoLogger.info "Test Message"

    MongoLogger::Config.mongo_db[MongoLogger::Config.collection_name].size.should == 1
  end
end
