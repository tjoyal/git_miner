module GitMiner
  class Core
    def initialize(engine:, dispatch:, prefix:)
      GitMiner.logger.info("Initializing")

      GitMiner.logger.debug("- Prefix: #{prefix}")
      GitMiner.logger.debug("- Engine: #{engine::IDENTIFIER}")
      GitMiner.logger.debug("- Dispatch: #{dispatch::IDENTIFIER}")

      @prefix = prefix

      @now = Time.now.utc

      @engine = engine.new(
        prefix: @prefix,
        now: @now,
      )

      @dispatch = dispatch.new(
        prefix: @prefix,
        engine: @engine
      )
    end

    def validate
      str = "Test content"
      expected = "bca20547e94049e1ffea27223581c567022a5774"

      current = @engine.sha1(str)

      unless expected == current
        message = <<~ERROR
          Invalid sha computation logic
          Expected:  #{expected} (#{expected.size})
          Generated: #{current} (#{current.size})
        ERROR

        raise(message)
      end

      unless @prefix[/^[0-9a-f]{1,32}$/]
        raise(UserError, "Invalid prefix, expected '^[0-9a-f]{1,32}$'")
      end

      GitMiner.logger.debug("Prefix validation: Accepted")
    end

    def mine
      GitMiner.logger.info("Mining for SHA: #{@prefix}")

      @mining_result = @dispatch.execute
    end

    def report
      raise "Prerequisite: Require mining to be completed first" unless @mining_result

      GitMiner.logger.debug("Mining completed.")
      GitMiner.logger.debug("Author offset: #{@mining_result.author_offset}")
      GitMiner.logger.debug("Committer offset: #{@mining_result.committer_offset}")
    end

    def alter
      raise "Prerequisite: Require mining to be completed first" unless @mining_result

      author_date = @now - @mining_result.author_offset
      committer_date = @now - @mining_result.committer_offset

      GitMiner.logger.debug("Amending git")
      GitUtil.update_current_ref(author_date, committer_date)

      GitMiner.logger.info("New SHA: #{@mining_result.sha}")
    end
  end
end
