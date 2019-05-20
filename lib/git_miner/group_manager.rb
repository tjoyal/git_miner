module GitMiner
  class GroupManager
    attr_reader :author_offset, :batch_size, :committer_offset, :count, :batch

    def initialize(batch_size:)
      @batch_size = batch_size

      @author_offset = 0
      @committer_offset = 0
      @batch = 0
      @count = 0
    end

    def advance!
      @batch_size.times do
        @committer_offset += 1

        if @committer_offset > @author_offset
          @author_offset += 1
          @committer_offset = 0
        end
      end

      @count += @batch_size
      @batch += 1
    end
  end
end