class ApplicationController < ActionController::Base

  def home

    render({ :template => "main_page/home.html.erb" })
  end

  def wait_time
    #Initial user inputs
    @airport_code = params.fetch(:airport_code)
    @pre_google_location = params.fetch(:location)



    #format user address and get lat/lon
    gmaps_api_endpoint = "https://maps.googleapis.com/maps/api/geocode/json?address=" + @pre_google_location + "&key=AIzaSyAgRzRHJZf-uoevSnYDTf08or8QFS_fb3U"
    require("open-uri")
    raw_data = URI.open(gmaps_api_endpoint).read

    require("json")
    parsed_data = JSON.parse(raw_data)
    results_array = parsed_data.fetch("results")
    first_results = results_array.at(0)
    @cleaned_address = first_results.fetch("formatted_address")

    geo = first_results.fetch("geometry")
    loc = geo.fetch("location")
    @origin_latitude =  loc.fetch("lat")
    @origin_longitude = loc.fetch("lng")  


    #generate lat/lon and name for airport using TSAWaittime API call
    tsa_wait_api_endpoint = "https://www.tsawaittimes.com/api/airport/IpFPh8X6u9f9t1B8wgGLMTLKO6tqQ1Pc/" + @airport_code
    raw_wait_time_data = URI.open(tsa_wait_api_endpoint).read
    parsed_wait_data = JSON.parse(raw_wait_time_data)
    @destination_lat = parsed_wait_data.fetch("latitude")
    @destination_lon = parsed_wait_data.fetch("longitude")
    @formatted_name = parsed_wait_data.fetch("name")
    p @destination_lat.class

    #find security line wait time
    @security_wait_time = parsed_wait_data.fetch("rightnow")



  #   Calculate Drive time
  #   https://maps.googleapis.com/maps/api/distancematrix/json
  # ?destinations=40.659569%2C-73.933783%7C40.729029%2C-73.851524%7C40.6860072%2C-73.6334271%7C40.598566%2C-73.7527626
  # &origins=40.6655101%2C-73.89188969999998
  # &key=AIzaSyAgRzRHJZf-uoevSnYDTf08or8QFS_fb3U

  gdistance_api_endpoint = "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=" + @destination_lat + "%2C" + @destination_lon + "&origins=" + @origin_latitude.to_s + "%2C" + @origin_longitude.to_s + "&key=AIzaSyAgRzRHJZf-uoevSnYDTf08or8QFS_fb3U"

  raw_dist_data = URI.open(gdistance_api_endpoint).to_s
  parsed_dist_data = JSON.parse(raw_dist_data)
  gdistance_results_rows = parsed_dist_data.fetch("rows")
  gdistance_results_elements = gdistance_results_rows.fetch("elements")
  gdistance_results_distance = gdistance_results_elements.fetch("distance")

  drive_time_seconds = gdistance_results_distance.fetch("value")
  @drive_time_mins = drive_time_seconds / 60 






    render({ :template => "main_page/wait_time.html.erb" })
  end
end
