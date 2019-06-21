def createNewList # create a new list for user
  list_name = gets.chomp
  WatchList.create(name: list_name)
   User.find_by(user_name: name).watch_lists << WatchList.last
end

def checking_stock # prints stock name and price
  puts "enter the stock symbol"
  name = gets.chomp
  puts Stock.api(name)
end

def existingLists
  watch_lists_array=User.find_by(user_name: name).watch_lists
  puts watch_lists_array.map{|watch_list| watch_list.name}
end


def deleteList
  puts "please enter the name of WatchList you want to delete"
  listName = gets.chomp
  WatchList.find_by(name: listName).delete
end
