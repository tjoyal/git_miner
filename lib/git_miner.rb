# Require all. Not ideal, only what is required based on the parameters should get to be required.
Dir[File.join(__dir__, 'git_miner', '**', '*.rb')].each do |file|
  require file
end

module GitMiner
  class UserError < StandardError; end

  class << self
    def logger
      return @logger if defined?(@logger)

      @logger = Logger.new(STDOUT)

      @logger.formatter = proc do |severity, datetime, _progname, msg|
        date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")

        if @logger.level == Logger::INFO
          "[GitMiner] #{msg}\n"
        else
          "[GitMiner] #{date_format} #{severity}: #{msg}\n"
        end
      end

      @logger
    end
  end
end
