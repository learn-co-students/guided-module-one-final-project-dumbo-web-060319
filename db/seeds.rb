 name_value = Stock.api("amd")
 WatchList.create(user_name:"test1" , symbol:name_value[0] , price:name_value[1] )

User.create(user_name:"test1")

Stock.create(symbol:name_value[0] , price: name_value[1])

 # stocks_symbols = Stock.symbols[0..10]
 # stocks_symbols.each do |symbol|
 # WatchList.create(user_name: "user1" , symbol: symbol)
 # end
