defmodule ScoreboardWeb.ScorekeeperLive do
  use Phoenix.LiveView

  alias ScoreboardWeb.ScorekeeperView

  def render(assigns) do
    Phoenix.View.render(ScorekeeperView, "index.html", assigns)
  end

  def mount(_session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(Scoreboard.PubSub, "score")

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
