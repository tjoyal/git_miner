module GitMiner
  class MiningResult
    attr_reader :sha, :author_offset, :committer_offset

    def initialize(sha:, author_offset:, committer_offset:)
      @sha = sha
      @author_offset = author_offset
      @committer_offset = committer_offset
    end
  end
end
