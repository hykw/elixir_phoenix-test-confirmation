defmodule Test.Router do
  use Test.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Test do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/ecto1", PageController, :ecto1
    get "/ecto1000", PageController, :ecto1000

    get "/ets1", PageController, :ets1
    get "/ets1000", PageController, :ets1000

    get "/agent1", PageController, :agent1
  end

  # Other scopes may use custom stacks.
  # scope "/api", Test do
  #   pipe_through :api
  # end
end
