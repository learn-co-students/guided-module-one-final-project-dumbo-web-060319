class Stock < ActiveRecord::Base
  has_many :watch_list_stocks
  has_many :watch_lists, through: :watch_list_stocks

  def self.api(stock_name = nil )
    if (stock_name.class == Array)
       stock_name = stock_name.join(',')
    end
    url = "https://financialmodelingprep.com/api/v3/stock/real-time-price/#{stock_name}"
    response = RestClient.get url
    parsed_response = JSON.parse(response.body).values

  end

  def self.symbols
    api.values[0].map{|hash| hash["symbol"]}
  end
  def self.lowest_to_highest
     api.values[0].map{|hash| hash.values}.sort_by{|array| array[1]}
  end
  def self.highest_to_lowest
     lowest_to_highest.reverse
  end

end
