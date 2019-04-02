defmodule ScoreboardWeb.ScoreLive do
  use Phoenix.LiveView

  alias ScoreboardWeb.ScoreView

  require Logger

  def render(assigns) do
    Logger.warn("in render")
    ScoreView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    Logger.warn("in mount")
    if connected?(socket) do
      subscribe = Phoenix.PubSub.subscribe(Scoreboard.PubSub, "score")
    else
      Logger.warn("not connected")
    end

    {:ok, state} = Scoreboard.GameState.state()

    socket =
      socket
      |> assign(:state, state)
      |> assign(:left_team, :team_a)
      |> assign(:right_team, :team_b)

    {:ok, assign(socket, :conn, socket)}
  end

  def handle_info(%Scoreboard.GameState.State{} = state, socket) do
    {:noreply, assign(socket, :state, state)}
  end
end
