require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/extensiontask"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Rake::ExtensionTask.new "git_miner_ext" do |ext|
  ext.lib_dir = "lib"
end

Rake::Task[:spec].prerequisites << :compile
