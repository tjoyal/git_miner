require 'parallel'
require 'concurrent'

module GitMiner
  module Dispatch
    class ParallelDispatch < AbstractDispatch
      class ShaFound < StandardError
        attr_reader :result

        def initialize(result)
          @result = result
        end
      end

      def perform
        Parallel.each(parallel_groups, in_processes: Concurrent.processor_count, preserve_results: false) do |group|
          author_offset, committer_offset = group

          result = @engine.mine(
            author_offset: author_offset,
            committer_offset: committer_offset,
            qty: @group_manager.batch_size
          )

          if result
            raise(ShaFound, result)
          end
        end
      rescue ShaFound => e
        e.result
      end

      def parallel_groups
        -> do
          author_offset = @group_manager.author_offset
          committer_offset = @group_manager.committer_offset

          @group_manager.advance!

          [
            author_offset,
            committer_offset
          ]
        end
      end
    end
  end
end
