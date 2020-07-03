require 'cookstyle'
require 'rubocop/rake_task'

namespace :style do
  desc 'Run chef cookbook style checks'
  RuboCop::RakeTask.new(:cookstyle) do |task|
    task.options << '--display-cop-names'
  end
end
