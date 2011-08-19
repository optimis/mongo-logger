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

    # def debug(message, attributes={})
    #   add(:debug, message, attributes)
    # end

    # def info(message, attributes={})
    #   add(:info, message, attributes)
    # end

    # def warn(message, attributes={})
    #   add(:warn, message, attributes)
    # end


    def initialize
      @collection = MongoLogger::Connection.connect
    end
    
    def add(level, message, attributes={})
      @collection.insert(:level => level.to_s, :message => message, :logged_at => Time.now, :attributes => attributes) if log_for_level?(level)
    end 

    private

    def log_for_level?(level)
      Levels[MongoLogger::Config.level] <= Levels[level]
    end

  end
end
