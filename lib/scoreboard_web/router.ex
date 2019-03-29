defmodule ScoreboardWeb.Router do
  use ScoreboardWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {ScoreboardWeb.LayoutView, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ScoreboardWeb do
    pipe_through :browser

    live("/", ScorekeeperLive)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ScoreboardWeb do
  #   pipe_through :api
  # end
end
