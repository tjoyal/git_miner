module GitMiner
  module Dispatch
    class AbstractDispatch
      IDENTIFIER = "N/A"

      BATCH_SIZE = 50_000

      def initialize(prefix:, engine:)
        @prefix = prefix
        @engine = engine

        @group_manager = GroupManager.new(batch_size: BATCH_SIZE)
      end

      def execute
        thread = Thread.new do
          progress = Progress.new(@prefix.length)
          loop do
            progress.tick(@group_manager.batch, @group_manager.count)
            sleep 1
          end
        end

        perform
      ensure
        thread.kill
      end

      private

      def perform
        raise NotImplementedError
      end
    end
  end
end
