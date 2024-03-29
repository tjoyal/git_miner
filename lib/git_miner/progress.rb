module GitMiner
  class Progress
    HISTORIC_SIZE = 10

    def initialize(prefix_length)
      @combinations = 16 ** prefix_length

      @historic = []
    end

    def tick(batch, count)
      update_historic(batch, count)
      report(count)
    end

    private

    def update_historic(batch, count)
      @historic << {
        batch: batch,
        count: count,
        timestamp: Time.now
      }

      if @historic.size > HISTORIC_SIZE
        @historic.shift
      end
    end

    def report(count)
      percentage = count * 100 / @combinations.to_f
      info = []

      historic_count = @historic.last[:count] - @historic.first[:count]
      historic_delay = @historic.last[:timestamp] - @historic.first[:timestamp]
      if historic_delay > 0
        per_sec = historic_count / historic_delay
        info << "hash: #{'%.0f' % per_sec}/s"

        per_sec = (@historic.last[:batch] - @historic.first[:batch]) / historic_delay
        info << "batches: #{'%.2f' % per_sec}/s"
      end

      if info.empty?
        GitMiner.logger.info("Mining estimate #{'%.2f' % percentage}%")
      else
        GitMiner.logger.info("Mining estimate #{'%.2f' % percentage}% (#{info.join(', ')})")
      end
    end
  end
end
