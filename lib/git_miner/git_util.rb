require 'open3'
require 'time'

module GitMiner
  class GitUtil
    class << self
      def commit_head
        # tree 2f18732a3837319fc7def49360366e435ca19700
        # parent 94d9a9d715847d1fed730ef74a664a6773989a1b
        # author Thierry Joyal <thierry.joyal@gmail.com> 1558198927 +0000
        # committer Thierry Joyal <thierry.joyal@gmail.com> 1558198927 +0000
        #
        # This is the commit message
        shell('git cat-file commit HEAD')
      end

      def update_current_ref(author_date, committer_date)
        commit_object = shell("git cat-file -p HEAD | head -n 2").chomp
        tree = shell("echo \"#{commit_object}\" | head -n 1 | cut -c 6-46").chomp
        head = shell("echo \"#{commit_object}\" | tail -n 1 | cut -c 8-48").chomp
        branch = shell("git branch | sed -n -e 's/^\\* \\(.*\\)/\\1/p'").chomp

        environment = {
          "GIT_AUTHOR_DATE" => author_date.iso8601,
          "GIT_COMMITTER_DATE" => committer_date.iso8601,
        }
        cmd = "git commit-tree #{tree} -p #{head} -F -"
        git_commit_message = shell('git log -1 --pretty=%B').chomp
        new_sha = shell(cmd, environment: environment, stdin_data: git_commit_message).chomp

        shell("git update-ref refs/heads/#{branch} #{new_sha}").chomp
      end

      private

      def shell(cmd, environment: {}, stdin_data: nil)
        puts "System call: #{cmd}"
        puts "environment: #{environment.inspect}" unless environment.empty?
        puts "stdin_data: #{stdin_data}" if stdin_data

        output, status = Open3.capture2(environment, cmd, stdin_data: stdin_data) #, chdir: @working_directory

        unless status.success?
          raise "Error on system call: #{output}, #{status}"
        end

        puts "result: #{output}"

        output
      end
    end
  end
end
