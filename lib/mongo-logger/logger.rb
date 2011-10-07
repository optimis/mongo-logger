module MongoLogger
  class Logger
    Levels = {
        :debug => 0,
        :info => 1,
        :warn => 2,
        :error => 3,
        :fatal => 4
      }

    Levels.keys.each do |level|
      define_method level do |*args|
        add(level, *args)
      end
    end

    def initialize
      @collection = MongoLogger::Connection.connect
    end
    
    def add(level, message, attributes={})
      truncate_attributes! attributes

      @collection.insert(:level => level.to_s, :message => message, :logged_at => Time.now, :attributes => attributes) if log_for_level?(level)
    end 

    private

    def truncate_attributes!(attributes)
      attributes.each do |key, value|
        if value.instance_of?(String) && value.size > 3000
          attributes[key] = value[0..2999] + '...'
        elsif value.instance_of? Hash 
          truncate_attributes!(value)      
        end
      end
    end

    def log_for_level?(level)
      Levels[MongoLogger::Config.level] <= Levels[level]
    end

  end
end
