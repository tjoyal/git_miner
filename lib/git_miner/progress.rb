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
      info = []

      percentage = count * 100 / @combinations.to_f
      info << "#{percentage.round(2)}%"

      historic_count = @historic.last[:count] - @historic.first[:count]
      historic_delay = @historic.last[:timestamp] - @historic.first[:timestamp]
      if historic_delay > 0
        per_sec = historic_count / historic_delay
        info << "hash: #{per_sec.round(2)}/s"

        per_sec = (@historic.last[:batch] - @historic.first[:batch]) / historic_delay
        info << "batches: #{per_sec.round(2)}/s"
      end

      puts info.join(', ')
    end
  end
end