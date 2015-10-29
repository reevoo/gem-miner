module GemMiner

  module Logger
    @@logger = STDOUT

    def self.logger=(logger)
      @@logger = logger
    end

    def log(message)
      @@logger.print message if @@logger
    end
  end

end
