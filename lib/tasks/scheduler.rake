desc "This task is called by the Heroku scheduler add-on"
task :reset_request_counter=> :environment do
  puts "Resetting counters for users..."
	users = User.where("date_part('day', current_date) = date_part('day',created_at)")
	users.update_all(requests_this_month: 0)
  puts "done."
end
