Rails.application.routes.draw do

  get("/", { :controller => "application", :action => "home" })
  get("/wait_time", { :controller => "application", :action => "wait_time" })


end
