class ApplicationController < ActionController::Base

  def home

    render({ :template => "main_page/home.html.erb" })
  end

  def wait_time
    @airport_code = params.fetch(:airport_code)
    render({ :template => "main_page/wait_time.html.erb" })
  end
end
