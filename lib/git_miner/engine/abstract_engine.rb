module GitMiner
  module Engine
    class AbstractEngine

      def sha1(_str)
        raise NotImplementedError
      end

      def initialize(prefix:, now:)
        @prefix = prefix

        @timestamp = now.to_i

        git_head = GitUtil.commit_head
        @git_head_tree ||= git_head[/^(tree.+?\n)/]
        @git_head_parent ||= git_head[/^(parent.+?\n)/]
        @git_head_author ||= git_head[/^(author.+?\n)/]
        @git_head_committer ||= git_head[/^(committer.+?\n)/]
        @git_head_message ||= git_head.gsub(/^(tree|parent|author|committer).+\n/, '')

        @git_head_author_prefix = @git_head_author.sub(/\d{10}.+?\n/, '')
        @git_head_committer_prefix = @git_head_committer.sub(/\d{10}.+?\n/, '')
      end

      def mine(author_offset:, committer_offset:, qty:)
        raise NotImplementedError
      end
    end
  end
end
