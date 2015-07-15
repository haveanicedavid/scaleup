require "populator"

desc "Adding Data for HubStb"
task :populate => :environment do
  @venues = Venue.all
  @categories = Category.all
  @images = Image.all
  
  User.populate(200_000) do |user|
    user.full_name = "Name_#{user.id}"
    user.email = "user_#{user.id}@example.com"
    user.slug = user.full_name.gsub(" ", "-")
    user.password_digest = "password"
    user.street_1 = "Address1_#{user.id}"
    user.street_2 = "Address2_#{user.id}"
    user.city = "New York"
    user.state = "NY"
    user.zipcode = 10000
    user.display_name = "User #{user.id}"
    puts "User #{user.id} created"
   end

   @users = User.all

  Event.populate(30_000) do |event|
    event.title = "Event_#{event.id}"
    event.description = "Description_#{event.id}"
    event.date = 21.days.from_now
    event.start_time = "2000-01-01 22:30:00"
    event.approved = true
    event.image_id = @images.sample.id
    event.venue_id = @venues.sample.id
    event.category_id = @categories.sample.id
    puts "Event #{event.id} created"
  end

  @events = Event.all
    
  Item.populate(500_000) do |item|
    item.unit_price = rand(1000..10000)
    item.pending = false
    item.sold = false
    item.section = rand(1..100)
    item.row = rand(1..50)
    item.seat = rand(1..20)
    item.delivery_method = "physical"
    item.event_id = @events.sample.id
    item.user_id = @users.sample.id
    puts "Item #{item.id} created"
  end

  Order.populate(50_000) do |order|
    order.user_id = @users.sample.id
    order.status = "ordered"
    puts "Order #{order.id} : For User #{order.user_id} has been created"
  end 

end 