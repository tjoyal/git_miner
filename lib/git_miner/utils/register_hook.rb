require 'fileutils'

module GitMiner
  class RegisterHook
    FILENAME = ".git/hooks/post-commit"

    class << self
      def register(prefix:)
        GitMiner.logger.info("Writing hook to #{FILENAME}")

        if File.exists?(FILENAME)
          File.open(FILENAME, 'a') do |file|
            file.puts("")
          end
        else
          FileUtils.touch(FILENAME)
          FileUtils.chmod("+x", FILENAME)
        end

        File.open(FILENAME, 'a') do |file|
          file.puts(
            "# GitMiner hook",
            "git mine #{prefix}"
          )
        end
      end
    end
  end
end
