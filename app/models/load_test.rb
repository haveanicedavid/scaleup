require 'capybara/poltergeist'

class LoadTest
  attr_reader :session

  ERRORS = [
  EOFError,
  NoMethodError,
  Errno::ECONNRESET,
  Errno::EINVAL,
  Errno::EBADF,
  Net::HTTPBadResponse,
  Net::HTTPHeaderSyntaxError,
  Net::ProtocolError,
  Timeout::Error,
  Capybara::ElementNotFound
]

  def initialize
    @session = Capybara::Session.new(:poltergeist)
  end

  def browse
      begin
        loop do
          visit_root
          click_adventure_for_random_event
          log_in("taytay@swift.com", "password")
          create_edit_delete_ticket
          view_past_orders
          edit_profile
          search_events
          log_out
          add_to_cart_create_account
          log_in("admin@admin.com", "password")
          admin_edit_event
          admin_delete_event
          admin_create_event
          admin_visit_venues
          admin_create_venue_and_delete_it
          admin_create_category_edit_and_delete_it
          log_out
          unauthorized_user_visits_admin_page
        end
        rescue StandardError => error
          puts "ERROR: #{error}"
          if session.find_link('Logout')
            log_out
            browse
          else
            browse
          end
      end
    end

  private

  def visit_root
    session.visit("http://ddanielscaleup.herokuapp.com/")
    puts "At root"
  end

  def unauthorized_user_visits_admin_page
    session.visit("http://ddanielscaleup.herokuapp.com/admin/venues")
    puts "unauthorized user tried to visit admin page"
  end

  def log_in(email, password)
    session.click_link("Login")
    session.fill_in "session[email]", with: email
    session.fill_in "session[password]", with: password
    session.click_link_or_button("Log in")
    puts "User is logged in"
  end

  def click_adventure_for_random_event
    visit_root
    session.click_link("Adventure")
    puts "Visited Adventure path"
  end

  def view_past_orders
    session.click_link("My Hubstub")
    session.click_link("Past Orders")
    session.click_link("My Hubstub")
    session.click_link("My Listings")
    puts "Viewed user's past orders"
  end

  def edit_profile
    session.click_link("My Hubstub")
    session.click_link("Manage Account")
    session.click_link("Edit User Profile")
    session.fill_in "user[city]", with: "Denver"
    session.click_button("Update Account")
    puts "Profile edited"
  end

  def create_edit_delete_ticket
    session.click_link("My Hubstub")
    session.click_link("List a Ticket")
    puts "Visited List a Ticket"
    session.fill_in "item[event_id]", with: rand(1..20000)
    session.fill_in "item[section]", with: "A3"
    session.fill_in "item[row]", with: "123"
    session.fill_in "item[seat]", with: "5"
    session.fill_in "item[unit_price]", with: 33
    session.select  "Electronic", from: "item[delivery_method]"
    session.click_button("List Ticket")
    puts "Created ticket"

    session.click_link("My Hubstub")
    session.click_link("My Listings")
    session.all(:css, "tr.item-row").last.click_button("Edit Listing")
    session.fill_in "item[section]", with: "A3"
    session.click_button("Submit")
    puts "Edited ticket"

    session.all(:css, "tr.item-row").last.click_button("Delete Listing")
    puts "Deleted ticket"
  end

  def log_out
    session.click_link("Logout")
    puts "User logged out"
  end

  def search_events
    session.click_link("Buy")
    session.click_link("All Tickets")
    session.click_link("All")
    session.click_link("Sports")
    session.click_link("Music")
    session.click_link("Comedy")
    session.click_link("Conference")
    session.click_link("Attaction")
    session.click_link("Tour")
    session.click_link("Seminar")
    session.click_link("Networking")
    session.click_link("Tournament")
    session.click_link("Festival")
    session.click_link("Rally")
    session.click_link("Expo")
    session.click_link("Party")
    puts "events filter used"
  end

  def add_to_cart_create_account
    session.click_link("Buy")
    session.click_link("All Tickets")
    session.all("p.event-name a").sample.click
    session.first(:button, "Add to cart").click
    puts "Item added to cart"
    session.click_link("Cart(1)")
    session.click_link("Checkout")
    session.click_link("here")


    session.fill_in "user[full_name]", with: "Shaq"
    session.fill_in "user[display_name]", with: ("A".."Z").to_a.shuffle.first(2).join
    session.fill_in "user[email]", with: (1..20).to_a.shuffle.join + "@sample.com"
    session.fill_in "user[street_1]", with: "Main St."
    session.fill_in "user[city]", with: "Denver"
    session.select  "Colorado", from: "user[state]"
    session.fill_in "user[zipcode]", with: "80301"
    session.fill_in "user[password]", with: "password"
    session.fill_in "user[password_confirmation]", with: "password"
    session.click_button("Create my account!")

    session.click_link("Cart(1)")
    session.click_link_or_button("Remove")
    puts "add item to cart, create account, and remove cart item"
  end


  def admin_edit_event
    session.click_link "Users"
    session.all("tr").sample.click_link "Store"
    puts "Admin visited admin users index"

    session.click_link "Events"
    session.click_link "Manage Events"
    session.all("tr").sample.click_link "Edit"
    session.fill_in "event[title]", with: ("A".."Z").to_a.shuffle.first(5).join
    session.fill_in "event[date]", with: 33.days.from_now.change({ hour: 5, min: 0, sec: 0  })
    session.fill_in "event[start_time]", with: "2000-01-01 19:00:00"
    session.click_button "Submit"
    puts "Admin edited event"
  end

  def admin_delete_event
    session.all("tr").sample.click_link "Delete"
    puts "Admin deleted event"
  end

  def admin_create_event
    session.click_link "Create Event"
    session.fill_in "event[title]", with: ("A".."Z").to_a.shuffle.first(5).join
    session.fill_in "event[description]", with: "No description necessary."
    session.fill_in "event[date]", with: 33.days.from_now.change({ hour: 5, min: 0, sec: 0  })
    session.fill_in "event[start_time]", with: "2000-01-01 19:00:00"
    session.click_button "Submit"
    puts "Admin created event"
  end

  def admin_visit_venues
    session.click_link "Events"
    session.click_link "Manage Venues"
    session.all("tr").last.click_link "Edit"
    session.fill_in "venue[location]", with: "Denver, CO"
    session.click_button("Submit")
    puts "Admin edited venue"
  end

  def admin_create_venue_and_delete_it
    session.click_link_or_button("Create Venue")
    session.fill_in "venue[name]", with: "fake venue"
    session.fill_in "venue[location]", with: "no where"
    session.click_button("Submit")
    puts "Admin created a venue"
    session.all("tr").last.click_link "Delete"
    puts "Admin deleted venue"
  end

  def admin_create_category_edit_and_delete_it
    session.click_link "Events"
    session.click_link "Manage Categories"
    session.click_link_or_button("Create Category")
    session.fill_in "category[name]", with: "Pizza"
    session.click_button("Submit")
    puts "Admin created category"

    session.all("tr").last.click_link "Edit"
    session.fill_in "category[name]", with: "Burritos"
    session.click_button("Submit")
    puts "Admin edited category"

    session.all("tr").last.click_link "Delete"
    puts "Admin deleted category"
  end

  def visit_random_venue_page
    session.visit("http://ddanielscaleup.herokuapp.com/venues/#{rand(1..15)}")
  end
end

# require 'capybara/poltergeist'
 
# class LoadTest
#   attr_reader :session
  
#   def initialize
#     @session = Capybara::Session.new(:poltergeist)
#   end
  
#   def guest_browse
#     begin
#         visit_root
#       loop do  
#         visit_random_venue_page
#         search_events
#         add_to_cart_create_account
#       end
#       rescue StandardError => error
#         puts "GUEST ERROR: #{error}"
#         guest_browse
#     end 
#   end
  
#   def user_stuff
#     begin
#       loop do
#         session.visit("http://ddanielscaleup.herokuapp.com/login")
#         log_in("bill@gates.com", "password")
#         create_ticket_then_edit_and_destroy
#         past_orders
#         edit_profile
#         log_out
#       end
#       rescue StandardError => error
#         puts "USER ERROR: #{error}"
#         if session.find_link('Logout')
#           log_out
#           user_stuff
#         else
#           user_stuff
#         end
#     end 
#   end
  
#   def admin_stuff
#     begin
#       loop do
#         session.visit("http://ddanielscaleup.herokuapp.com/login")
#         log_in("admin@admin.com", "password")
#         admin_edit_event
#         admin_delete_event
#         admin_create_event
#         admin_visit_venues
#         admin_create_venue_and_delete_it
#         admin_create_category_edit_and_delete_it
#         log_out
#       end
#       rescue StandardError => error
#         puts "ADMIN ERROR: #{error}"
#         if session.find_link('Logout')
#           log_out
#           admin_stuff
#         else
#           admin_stuff
#         end
#     end 
#   end
  
#   def visit_root
#     session.visit("http://ddanielscaleup.herokuapp.com")
#     # session.visit("http://localhost:3000")
#   end
  
#   def log_in(email, password)
#     session.click_link("Login")
#     session.fill_in "session[email]", with: email
#     session.fill_in "session[password]", with: password
#     session.click_link_or_button("Log in")
#     puts "Login"
#   end
  
#   def past_orders
#     session.click_link("My Hubstub")
#     session.click_link("Past Orders")
#     session.click_link("My Hubstub")
#     session.click_link("My Listings")
#   end
  
#   def edit_profile
#     session.click_link("My Hubstub")
#     session.click_link("Manage Account")
#     session.click_link("Edit User Profile")
#     session.fill_in "user[city]", with: "Portland"
#     session.click_button("Update Account")
#   end
  
#   def create_ticket_then_edit_and_destroy
#     session.click_link("My Hubstub")
#     session.click_link("List a Ticket")
#     session.fill_in "item[event_id]", with: rand(1..20000)
#     session.fill_in "item[section]", with: "FA"
#     session.fill_in "item[row]", with: "555"
#     session.fill_in "item[seat]", with: "60"
#     session.fill_in "item[unit_price]", with: 30
#     session.select  "Electronic", from: "item[delivery_method]"
#     session.click_button("List Ticket")
#     puts "New ticket created"
    
#     session.click_link("My Hubstub")
#     session.click_link("My Listings")
#     session.all("tr.item-row").last.click_button("Edit Listing")
#     session.fill_in "item[section]", with: "AA"
#     session.click_button("Submit")
    
#     session.all("tr.item-row").last.click_button("Delete Listing")
    
#     puts "ticket edited and deleted"
#   end
  
#   def log_out
#     session.click_link("Logout")
#     puts "Logout"
#   end
  
#   def search_events
#     session.click_link("Buy")
#     session.click_link("All Tickets")
#     session.click_link("All")
#     session.click_link("Sports")
#     session.click_link("Music")
#     session.click_link("Theater")
#     # session.click_link("Circus")
#     session.click_link("Rodeo")
#     session.click_link("Rock")
#     session.click_link("All")
#     puts "used events filter"
#   end
  
#   def add_to_cart_create_account
#     session.click_link("Johnny Cash")
#     # session.all("tr").sample.find(:css, "input.btn").click
#     session.all(:css, "input.btn").sample.click
#     puts "one thing added to cart"
#     session.click_link("Cart(1)")
#     session.click_link("Checkout")
#     session.click_link("here")
    
#     session.fill_in "user[full_name]", with: "Kristina B"
#     session.fill_in "user[display_name]", with: ("A".."Z").to_a.shuffle.first(2).join
#     session.fill_in "user[email]", with: (1..20).to_a.shuffle.join + "@sample.com"
#     session.fill_in "user[street_1]", with: "main st"
#     session.fill_in "user[city]", with: "Portland"
#     session.select  "Oregon", from: "user[state]"
#     session.fill_in "user[zipcode]", with: "97215"
#     session.fill_in "user[password]", with: "password"
#     session.fill_in "user[password_confirmation]", with: "password"
#     session.click_button("Create my account!")
    
#     session.click_link("Cart(1)")
#     session.click_link_or_button("Remove")
#     puts "add item to cart, create account, and remove it"
#   end
  
#   def admin_edit_event
#     session.click_link "Users"
#     session.all("tr").sample.click_link "Store"
#     puts "visited admin users index"
#     session.click_link "Events"
#     session.click_link "Manage Events"
#     puts session.current_path
#     session.all("tr").sample.click_link "Edit"
#     session.fill_in "event[title]", with: ("A".."Z").to_a.shuffle.first(5).join
#     session.fill_in "event[date]", with: 33.days.from_now.change({ hour: 5, min: 0, sec: 0  })
#     session.fill_in "event[start_time]", with: "2000-01-01 19:00:00"
#     session.click_button "Submit"
#     puts "event edited by admin"
#   end
  
#   def admin_delete_event
#     session.all("tr").sample.click_link "Delete"
#   end
  
#   def admin_create_event
#     session.click_link "Create Event"
#     session.fill_in "event[title]", with: ("A".."Z").to_a.shuffle.first(5).join
#     session.fill_in "event[description]", with: "No description necessary."
#     session.fill_in "event[date]", with: 33.days.from_now.change({ hour: 5, min: 0, sec: 0  })
#     session.fill_in "event[start_time]", with: "2000-01-01 19:00:00"
#     session.click_button "Submit"
#     puts "admin create event"
#   end
  
#   def admin_visit_venues
#     session.click_link "Events"
#     session.click_link "Manage Venues"
#     session.all("tr").last.click_link "Edit"
#     session.fill_in "venue[location]", with: "Denver, CO"
#     session.click_button("Submit")
#     puts "venue edited"
#   end
  
#   def admin_create_venue_and_delete_it
#     session.click_link_or_button("Create Venue")
#     session.fill_in "venue[name]", with: "fake venue"
#     session.fill_in "venue[location]", with: "no where"
#     session.click_button("Submit")
#     session.all("tr").last.click_link "Delete"
#     puts "venue created and deleted"
#   end
  
#   def admin_create_category_edit_and_delete_it
#     session.click_link "Events"
#     session.click_link "Manage Categories"
#     session.click_link_or_button("Create Category")
#     session.fill_in "category[name]", with: "fake category"
#     session.click_button("Submit")
    
#     session.all("tr").last.click_link "Edit"
#     session.fill_in "category[name]", with: "still fake"
#     session.click_button("Submit")
    
#     session.all("tr").last.click_link "Delete"
#     puts "category created, edited, and deleted"
#   end   
  
#   def visit_random_venue_page
#     session.click_link("Adventure")
#     session.visit("http://ddanielscaleup.herokuapp.com/venues/#{rand(1..15)}")
#   end
# end