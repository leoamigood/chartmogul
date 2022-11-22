# frozen_string_literal: true

namespace :hipolabs do
  desc 'Load universities data by specific country'
  task :discover, [:country] => [:environment] do |_task, args|
    UniversityDiscoveryJob.perform_async(args.first[1])
  end
end
