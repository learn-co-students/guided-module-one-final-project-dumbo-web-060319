class CLI
  def initialize
    @prompt = TTY::Prompt.new
  end

  def welcome_menu
    puts `clear`
    @prompt.select("please select one of these options") do |menu|
      menu.choice "New User", -> { new_user }
      menu.choice "Sign In", -> { sign_in }
      menu.choice "Just Looking", -> { no_user_checking_stock }
      menu.choice "Exit", -> { puts "Thanks for using my app... Take care!"}
    end
  end

  def main_menu
    puts `clear`
    TTY::Prompt.new.select("please select one of these options") do |menu|

      menu.choice "Create New List",           -> { create_a_watchlist }
      menu.choice "See my Watchlists",         -> { view_my_watchlist }
      menu.choice "Delete a Watchlist",        -> { delete_a_watchlist }
      menu.choice "Update a Watchlist",        -> { update_a_watchlist }
      menu.choice "Check a Stock Price",       -> { checking_stock }
      menu.choice "Show All stocks",            ->{ allstocks }
      menu.choice "Sign Out",                  -> { welcome_menu }
      menu.choice "Exit"

    end
  end

  def new_user  #  creates new user =>  directs user to his account
    puts `clear`
    @current_user = User.create(user_name: @prompt.ask("please enter your name"))
    puts "you successfully created a new user account"
    login_message
    main_menu
  end

  def sign_in
    puts `clear`
    @current_user = User.find_by(user_name: @prompt.ask("please enter your username"))
    puts "Welcome back #{@current_user.user_name} here's your watch lists"
    login_message
    main_menu
  end

  def create_a_watchlist
    WatchList.create(name: @prompt.ask("Enter the name of the watch list you want to create"))
     User.find_by(user_name: @current_user.user_name ).watch_lists << WatchList.last
     puts "YoHHOOOO you just created a new watch list #{@current_user.user_name}"
     @prompt.select("") { |menu| menu.choice "Go Back", -> { main_menu }}
   end


  def get_watchlist_details(watchlist)
    puts "name: #{watchlist.name}"
    puts WatchList.find_by(name: "#{watchlist.name}").stocks.pluck(:symbol , :price)
    @prompt.select('') { |menu| menu.choice "go back", -> { view_my_watchlist } }
  end


  def update_a_watchlist
    puts"Type the name of a watchlist you wanna add stock....."
    puts User.find_by(user_name: @current_user.user_name).watch_lists.pluck(:name)
    watchlist =  gets.chomp
    add_stock_to_watchlist(watchlist)
    @prompt.select("") {|menu| menu.choice "go back", -> { main_menu }}
      #add_stock_to_watchlist(watchlist)
  end

  def delete_a_watchlist
    puts `clear`
    @prompt.select("Please select a watchlist to remove (¡WARNING: You will lose all stocks from that watchlist!)") do |menu|
      @current_user.watch_lists.each do |watchlist|
          menu.choice watchlist.name, -> { watchlist.destroy; @current_user.reload; main_menu }
      end
      menu.choice "Return to main menu", -> { main_menu }
    end
  end

  def view_my_watchlist
    puts `clear`
    @prompt.select("Here are your watchlists:") do |menu|
      @current_user.watch_lists.each do |watchlist|
        menu.choice watchlist.name, -> { get_watchlist_details(watchlist); @current_user.reload}
      end
      menu.choice "Return to main menu", -> { main_menu }
    end
  end

  def current_stocks_in_watchlist(watchlist)
    puts WatchList.find_by(name: watchlist.name).stocks.pluck(:symbol , :price)
  end

  def add_stock_to_watchlist(watchlist)
    stock_info = Stock.api(@prompt.ask("please enter a ticker to add into stock list"))
    Stock.create(symbol: stock_info[0], price: stock_info[1])
    WatchList.find_by(name: watchlist).stocks << Stock.last
    puts "#{stock_info[0]} has been added to your list, #{watchlist}"
  end

  def allstocks
    puts User.find_by(user_name: @current_user.user_name).stocks.pluck(:symbol , :price)
    @prompt.select("") { |menu| menu.choice "Go Back", -> { main_menu } }
  end

  def checking_stock # prints stock name and price
    puts Stock.api(@prompt.ask("enter the stock symbol"))
    @prompt.select("") { |menu| menu.choice "Go Back", -> { main_menu } }
  end
  def  no_user_checking_stock
    puts Stock.api(@prompt.ask("enter the stock symbol"))

    @prompt.select("") { |menu| menu.choice "Go Back", -> { welcome_menu } }
  end

  def login_message
    print "logging you in"
    "....".each_char { |letter| print(letter); sleep(0.5) }
  end
end















# prompt = TTY::Prompt.new
# puts "welocome , please select on of these options"




###### user sign in page
# def sign_in
#   puts "please enter your user name"
#   name = gets.chomp
#   puts "Weolcome back #{name} here's your watch lists"
#   selection = TTY::Prompt.new.select("please select one of these options", %w( YourExistingLists  CreateNewList openAlist))
#
#
#     if selection == "YourExistingLists"
#       watch_lists_array=User.find_by(user_name: name).watch_lists
#       puts watch_lists_array.map{|watch_list| watch_list.name}
#     #
#     # elsif selection == "CreateNewList"
#     #   list_name = gets.chomp
#     #   WatchList.create(name: list_name)
#     #    User.find_by(user_name: name).watch_lists << WatchList.find_by(name: list_name)
#
#      elsif selection == "openAlist"
#        puts "hy #{name} heres all of your watch lists"
#        watch_lists_array=User.find_by(user_name: name).watch_lists
#
#        puts watch_lists_array.map{|watch_list| watch_list.name} ### shows user his Watch list
#        puts "Type the name of the list you want to open"
#        list_name = gets.chomp
#        puts "heres a list of all the stocks in #{list_name} watchlist" ## shows user list of stocks in his watch list
#        puts WatchList.find_by(name: list_name).stocks
#        select_stock = TTY::Prompt.new.select("please select one of these options", %w( AddStock deleteStock ))
#        if select_stock == "AddStock"
#          puts "please enter a ticker to add stock"
#          stock_to_find = gets.chomp
#          stock_array = Stock.api(stock_to_find)
#          Stock.create(symbol: stock_array[0], price: stock_array[1])
#          WatchList.find_by(name: list_name).stocks << Stock.last
#        elsif select_stock == "deleteStock"
#          WatchList.find_by(name: "first stock list").stocks.find_by(symbol: "aod").delete
#
#        end
#
#      end
#
#
# end
#
#
#
#
#
#
#
