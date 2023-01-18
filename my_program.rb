require("open-uri")
require("json")
puts "===============================" 
puts "Will you need an umbrella today"
puts "===============================" 
puts ""
puts "Where are you located?"

user_location = gets.chomp

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")

gmaps = JSON.parse(URI.open(gmaps_url).read)

latitude = gmaps.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lat")

longtitude = gmaps.fetch("results").at(0).fetch("geometry").fetch("location").fetch("lng")

dark_sky_url = "https://api.darksky.net/forecast/" + ENV.fetch("DARK_SKY_KEY")+"/"+ latitude.to_s+","+longtitude.to_s

dark_sky = JSON.parse(URI.open(dark_sky_url).read)

current_temp = dark_sky.fetch("currently").fetch("temperature")

next_hour = dark_sky.fetch("hourly").fetch("data").fetch(0).fetch("summary")
# Display info

puts "Checking the weather at " + user_location.capitalize + "...."
puts "Your coordinates are " + latitude.to_s+", "+longtitude.to_s+"."
puts "It is currently " + current_temp.to_s + "°F"

puts "Next hour: " + next_hour.to_s + " for the hour"

hour_var = 0
max_precip = 0
while hour_var < 12
  precipitation = dark_sky.fetch("hourly").fetch("data").fetch(hour_var).fetch("precipProbability")

  if precipitation > 0.1
    puts "In " + hour_var.to_s + " hours, there is a " + (precipitation*100).to_i.to_s + "% chance of precipitation."
    max_precip = [max_precip, precipitation].max
  end
  hour_var = hour_var + 1
end

if max_precip > 0.2
  puts "You might want to carry an umbrella!"
else
  puts "You probably won't need an umbrella today."
end
