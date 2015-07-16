require 'capybara/poltergeist'

desc "Simulate load against HubStub application"
task :load_test => :environment do
  4.times.map { Thread.new { LoadTest.new.browse } }.map(&:join)
  # LoadTest.new.browse 
end