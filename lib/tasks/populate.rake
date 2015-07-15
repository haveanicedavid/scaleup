require "populator"

desc "Simulate load against HubStub application"
task :populate => :environment do
  @venues     = Venue.all
  @categories = Category.all
  @images     = Image.all

  event_count = 0
  Event.populate(30_000) do |event|
    event.title       = Faker::Company.name
    event.description = Faker::Company.catch_phrase
    event.date        = 22.days.from_now
    event.start_time  = "2000-01-01 22:30:00"
    event.approved    = true
    event.image_id    = @images.sample.id
    event.venue_id    = @venues.sample.id
    event.category_id = @categories.sample.id
    event_count += 1
    puts "Event number #{event_count} created"
  end
  
  @events = Event.all
  
  user_count = 0
  item_count = 0
  User.populate(200_000) do |user|
    user.full_name       = Faker::Name.name
    user.slug            = user.full_name.gsub(" ", "-")
    user.email           = Faker::Internet.email
    user.password_digest = "password"
    user.street_1        = Faker::Address.street_address
    user.street_2        = Faker::Address.secondary_address
    user.city            = Faker::Address.city
    user.state           = Faker::Address.state
    user.zipcode         = 39247
    user.display_name    = Faker::Internet.user_name

    user_count += 1
    puts "User number #{user_count} created"
    
    
    Item.populate(3) do |item|
      item.unit_price      = rand(1000..10000)
      item.pending         = false
      item.sold            = false
      item.section         = rand(1..100)
      item.row             = rand(1..50)
      item.seat            = rand(1..20)
      item.delivery_method = "physical"
      item.event_id        = @events.sample.id
      item.user_id         = user.id

      item_count += 1
      puts "Item number #{item_count} created"
    end
  end

  order_count = 0
  Order.populate(50_000) do |order|
    users = User.all.count
    order.status = "ordered"
    order.user_id = rand(1..users)
    order.total_price = rand(1000..100000)
    order_count += 1
    puts "order #{order_count} created"
  end

end