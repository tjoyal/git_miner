require 'digest'

module GitMiner
  module Engine
    class RubyEngine < AbstractEngine
      def sha1(str)
        Digest::SHA1.hexdigest(str)
      end

      def mine(author_offset:, committer_offset:, qty:)
        qty.times do
          current_sha = generate_sha(author_offset, committer_offset)

          if current_sha.start_with?(@prefix)
            return MiningResult.new(
              sha: current_sha,
              author_offset: author_offset,
              committer_offset: committer_offset,
            )
          end

          committer_offset += 1
          if committer_offset > author_offset
            author_offset += 1
            committer_offset = 0
          end
        end

        nil
      end

      private

      # TODO: handle multiple author/committer
      def generate_sha(author_offset, committer_offset)
        commit_head = @git_head_tree
        commit_head += @git_head_parent
        commit_head += @git_head_author_prefix + (@timestamp - author_offset).to_s + " +0000\n"
        commit_head += @git_head_committer_prefix + (@timestamp - committer_offset).to_s + " +0000\n"
        commit_head += @git_head_message

        str = "commit #{commit_head.size}\0#{commit_head}"
        Digest::SHA1.hexdigest(str)
      end
    end
  end
end