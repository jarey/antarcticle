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
      get("/users/user1").should route_to("users#show", username: "user1")
      get("/users/user.1").should route_to("users#show", username: "user.1")
      get("/users/u$er@").should route_to("users#show", username: "u$er@")
    end
  end

  describe "tags routing" do
    it "should route to tags#index" do
      get("/tags/tag1").should route_to("tags#index", tags: "tag1")
      get("/tags/node.js").should route_to("tags#index", tags: "node.js")
      get("/tags/tag1+tag2").should route_to("tags#index", tags: "tag1+tag2")
      get("/tags/tag.1+tag.2").should route_to("tags#index", tags: "tag.1+tag.2")
      get("/tags/%2F").should route_to("tags#index", tags: "/")
      get("/tags/.").should route_to("tags#index", tags: ".")
      get("/tags/%3Cstyle%3E%20*%7Bborder:%20solid%201px%20red;%7D%3C/style%3E").should route_to("tags#index", tags: "<style> *{border: solid 1px red;}</style>")
    end

    it "should route to tags#tags_filter" do
      get("/tags_filter").should route_to("tags#filter")
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
      get("/articles/1").should route_to("articles#show", id: "1")
    end

    it "routes to #edit" do
      get("/articles/1/edit").should route_to("articles#edit", id: "1")
    end

    it "routes to #create" do
      post("/articles").should route_to("articles#create")
    end

    it "routes to #update" do
      put("/articles/1").should route_to("articles#update", id: "1")
    end

    it "routes to #destroy" do
      delete("/articles/1").should route_to("articles#destroy", id: "1")
    end

  end

  describe "comments routing" do
    it "routes to #create" do
      post("/articles/1/comments").should route_to("comments#create", article_id: "1")
    end

    it "routes to #update" do
      put("/articles/1/comments/2").should route_to("comments#update", article_id: "1", id: "2")
    end

    it "routes to #destroy" do
      delete("/articles/1/comments/2").should route_to("comments#destroy", article_id: "1", id: "2")
    end
  end
end
