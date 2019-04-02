defmodule ScoreboardWeb.ScoreLive do
  use Phoenix.LiveView

  alias ScoreboardWeb.ScoreView

  require Logger

  def render(assigns) do
    ScoreView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, state} = Scoreboard.GameState.state()

    socket =
      socket
      |> assign(:state, state)
      |> assign(:left_team, :team_a)
      |> assign(:right_team, :team_b)

    Logger.debug(inspect(socket), label: "socket")

    {:ok, assign(socket, :conn, socket)}
  end
end
