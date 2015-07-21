require 'rake/testtask'

Rake::TestTask.new(:spec) do |task|

  task.libs<< 'spec'

  task.warning    = false
  task.verbose    = false
  task.test_files = FileList['spec/*_spec.rb']
end

task :default => :spec
