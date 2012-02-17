require "mongo-logger/version"


require 'config/mongologger_config'


require 'mongo-logger/connection'
require 'mongo-logger/logger'

require 'mongo'
require 'logger'

#configs that should not be changed
module MongoLogger
  module Config
    def self.collection_name
      'log_statements'
    end
    def self.buffer_count
      500
    end
  end
end

module MongoLogger
  def self.logger
    @logger ||= Logger.new('log/mongologger_log.log')
  end
end
