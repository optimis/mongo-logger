require 'spec_helper'

describe MongoLogger::Logger do
  before do
    Timecop.freeze
    @collection = MongoLogger::Connection.connect
  end

  after do
    Timecop.return
    @collection.drop
  end
  subject { MongoLogger::Logger.new }

  describe '#debug' do
    it 'should log the statement in mongo' do
      MongoLogger::Config.stub!(:level).and_return(:debug)
      subject.debug 'message'
      @collection.find.first['level'].should == 'debug'
      @collection.find.first['message'].should == 'message'
      @collection.find.first['attributes'].should == {} 
    end  
  end

  describe '#info' do
    it 'should log the statement in mongo' do
      subject.info 'message'
      @collection.find.first['level'].should == 'info'
      @collection.find.first['message'].should == 'message'
      @collection.find.first['attributes'].should == {} 
    end  
  end

  describe '#warn' do
    it 'should log the statement in mongo' do
      subject.warn 'message', 'hi' => 'me'
      @collection.find.first['level'].should == 'warn'
      @collection.find.first['message'].should == 'message'
      @collection.find.first['attributes'].should == {'hi' => 'me'} 
    end  
  end

  describe '#error' do
    it 'should log the statement in mongo' do
      subject.error 'message'
      @collection.find.first['level'].should == 'error'
      @collection.find.first['message'].should == 'message'
      @collection.find.first['attributes'].should == {} 
    end  
  end

  describe '#fatal' do
    it 'should log the statement in mongo' do
      subject.fatal 'message'
      @collection.find.first['level'].should == 'fatal'
      @collection.find.first['message'].should == 'message'
      @collection.find.first['attributes'].should == {} 
    end  
  end

  describe '#add' do
    before { subject.add :info, "Test Message" } 
    it 'should log a message' do
      @collection.size.should == 1
    end

    it 'should store the log level' do
      @collection.find.first['level'].should == 'info' 
    end

    it 'should store the log message' do
      @collection.find.first['message'].should == 'Test Message'
    end

    it 'should store the time it was logged' do
      @collection.find.first['logged_at'].should == Time.now
    end

    it 'should log optional key value pairs as log attribues' do
      subject.add :error, "Test Message", 'application' => 'app one', 'workflow' => 'ETL'

      @collection.find('level' => 'error').first['attributes'].should == {'application' => 'app one', 'workflow' => 'ETL'}
    end

    it 'should not log the message if the log level is below the configured level' do
      subject.add :debug, "My Message"

      @collection.size.should == 1
    end


    it 'should log messages for higher levels' do
      subject.add :error, "big error"

      @collection.size.should == 2
    end

  end
end
