class ApplicationController < ActionController::Base

  def home

    render({ :template => "main_page/home.html.erb" })
  end

  def wait_time
    @airport_code = params.fetch(:airport_code)
    @pre_google_location = params.fetch(:location)

    gmaps_api_endpoint = "https://maps.googleapis.com/maps/api/geocode/json?address=" + @pre_google_location + "&key=AIzaSyAgRzRHJZf-uoevSnYDTf08or8QFS_fb3U"
    require("open-uri")
    raw_data = URI.open(gmaps_api_endpoint).read

    require("json")
    parsed_data = JSON.parse(raw_data)
    results_array = parsed_data.fetch("results")
    first_results = results_array.at(0)
    @cleaned_address = first_results.fetch("formatted_address")


    render({ :template => "main_page/wait_time.html.erb" })
  end
end
