module GitMiner
  module Dispatch
    class SimpleDispatch < AbstractDispatch
      IDENTIFIER = "Simple"

      def perform
        loop do
          result = @engine.mine(
            author_offset: @group_manager.author_offset,
            committer_offset: @group_manager.committer_offset,
            qty: @group_manager.batch_size
          )

          unless result
            @group_manager.advance!
            next
          end

          return result
        end
      end
    end
  end
end
