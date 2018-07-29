defmodule PagiWeb.Router do
  use PagiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :graph do
    plug :accepts, ["json"]
  end

  scope "/graph" do
    pipe_through :graph

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: PagiWeb.Schema

    forward "/", Absinthe.Plug,
      schema: PagiWeb.Schema
  end

  scope "/", PagiWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end
end
