require 'capybara/poltergeist'

desc "Simulate load for scale-up application"
task :load_test => :environment do
  4.times.map { Thread.new { LoadTest.new.browse } }.map(&:join)
  # [ Thread.new { LoadTest.new.guest_browse }, Thread.new { LoadTest.new.user_stuff }, Thread.new { LoadTest.new.admin_stuff } ].map(&:join)  
end