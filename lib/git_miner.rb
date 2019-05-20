# Require all. Not ideal, only what is required based on the parameters should get to be required.
Dir[File.join(__dir__, 'git_miner', '**', '*.rb')].each do |file|
  require file
end

module GitMiner
  class Error < StandardError; end
end
