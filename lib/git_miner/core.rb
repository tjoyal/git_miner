module GitMiner
  class Core
    def initialize(engine:, dispatch:, prefix:)
      puts "Initializing with engine '#{engine}'. dispatch '#{dispatch}' and prefix '#{prefix}'"

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
        raise "Invalid prefix, expected '^[0-9a-f]{1,32}$'"
      end

      puts "Validations: Successful"
    end

    def mine
      puts "Mining for sha"

      @mining_result = @dispatch.execute
    end

    def report
      raise "Prerequisite: Require mining to be completed first" unless @mining_result

      puts "Mining results:"
      puts "- New sha: #{@mining_result.sha}"
      puts "- Author offset: #{@mining_result.author_offset}"
      puts "- Committer offset: #{@mining_result.committer_offset}"
    end

    def alter
      raise "Prerequisite: Require mining to be completed first" unless @mining_result

      author_date = @now - @mining_result.author_offset
      committer_date = @now - @mining_result.committer_offset

      GitUtil.update_current_ref(author_date, committer_date)
    end
  end
end