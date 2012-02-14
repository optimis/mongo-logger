require 'spec_helper'

describe MongoLogger::Connection do
  after do
    MongoLogger::Connection.connect.remove if MongoLogger::Connection.connect.respond_to? :remove
  end
  subject { MongoLogger::Connection.connect}

  describe '.connect' do
    it 'should open the connection to mongo' do
      subject.name.should == MongoLogger::Config.collection_name
      subject.db.name.should == MongoLogger::Config.mongo_connection[:database]
      subject.db.connection.primary[0].should == MongoLogger::Config.mongo_connection[:host]
      subject.db.connection.primary[1].should == 27017
    end

    it 'should open connection to mongo when gem is loaded' do
      subject.should be_instance_of Mongo::Collection
    end

    it 'should create the capped collection if it does not exist' do
      subject.stats['capped'].should == 1
    end

    context 'stubbed' do
      before :each do
        module MongoLogger
          module Config
            def self.stubbed?
              true
            end
          end
        end
      end
      after :each do
        module MongoLogger
          module Config
            # remove_method :stubbed?
          end
        end
      end
      it 'should not connect to mongo' do
        Mongo::Connection.should_not_receive :new

        subject
      end

      it 'should return an object that responds to insert with any number of actions' do
        lambda do
          subject.insert
          subject.insert "adsf"
          subject.insert "asdf", {:asdf => "afd"}
        end.should_not raise_error
      end
    end
  end
end
