defmodule EdmBackend.Router do
  use EdmBackend.Web, :router

  pipeline :default do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug EdmBackend.Plug.RemoteIp
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/", EdmBackend do
    pipe_through :default # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/auth", EdmBackend do
    pipe_through :default

    get "/api/:provider", AuthController, :api_request
    get "/api", AuthController, :api_request

    get "/:provider", AuthController, :request
    get "/", AuthController, :request

    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  # Other scopes may use custom stacks.
  scope "/api/v1/" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug.GraphiQL, schema: EdmBackend.GraphQL.Schema

  end

end
