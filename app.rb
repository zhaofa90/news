require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "3faf7b7928acf2aa803cf68d3236e289"

# INPUT PAGE

get "/" do
    view "ask"
end


# OUTPUT PAGE

	get "/news" do
    
        
# WEATHER

    @results = Geocoder.search(params["q"])
    @location = params["q"]
    @lat_long = @results.first.coordinates
   

	@forecast = ForecastIO.forecast(@lat_long[0],@lat_long[1]).to_hash 
    @conditions = @forecast["currently"]["summary"]
   	@tempnow = @forecast["currently"]["temperature"]

    
    hightemp = []
    status = []
    @temp = hightemp
    @condition = status
    

	for day in @forecast["daily"]["data"]
	hightemp << "#{day["temperatureHigh"]}"
	status << "#{day["summary"]}"
    end
    
    
# NEWS 

    @url = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=9282408351c74c35b014883a3a4f2e8d"
	@news = HTTParty.get(@url).parsed_response.to_hash
	
    headline_link = []
	for headlines in @news["articles"]
	headline_link << "#{headlines["url"]}"
    end
    
    @headline = headline_link
	
	headline_main = []
	for headlinetitles in @news["articles"]
	headline_main << "#{headlinetitles["title"]}"
	end
    
    @titles = headline_main

    
	view "news"
	end