require "spec_helper"

describe "routing" do

  describe "root" do
    it "should route to articles#index" do
      get("/").should route_to("articles#index")
    end
  end

  describe "authentication routing" do
    it "should route to sessions#new" do
      get("/signin").should route_to("sessions#new")
    end

    it "should route to sessions#destroy" do
      delete("/signout").should route_to("sessions#destroy")
    end
  end

  describe "users routing" do
    it "should route to users#show" do
      get("/users/user1").should route_to("users#show", :username => "user1")
    end
  end

  describe "articles routing" do

    it "routes to #index" do
      get("/articles").should route_to("articles#index")
    end

    it "routes to #new" do
      get("/articles/new").should route_to("articles#new")
    end

    it "routes to #show" do
      get("/articles/1").should route_to("articles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/articles/1/edit").should route_to("articles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/articles").should route_to("articles#create")
    end

    it "routes to #update" do
      put("/articles/1").should route_to("articles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/articles/1").should route_to("articles#destroy", :id => "1")
    end

  end
end