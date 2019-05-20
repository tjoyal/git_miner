require 'git_miner_ext'

module GitMiner
  module Engine
    class CExtensionEngine < AbstractEngine
      include GitMinerExt

      def sha1(str)
        c_sha1_hexdigest(str)
      end

      def mine(author_offset:, committer_offset:, qty:)
        c_sha1_mine(author_offset, committer_offset, qty)

        # From C mutations
        if @result_current_sha
          MiningResult.new(
            sha: @result_current_sha,
            author_offset: @result_author_offset,
            committer_offset: @result_committer_offset,
          )
        else
          nil
        end
      end
    end
  end
end
