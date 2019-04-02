defmodule ScoreboardWeb.ScorekeeperLive do
  use Phoenix.LiveView

  alias ScoreboardWeb.ScorekeeperView

  require Logger

  def render(assigns) do
    ScorekeeperView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    Logger.error(connected?(socket), label: "socket connected?")
    {:ok, %{current_set: {a, b}} = state} = Scoreboard.GameState.state()

    socket =
      socket
      |> assign(:score, %{left: a, right: b})
      |> assign(:state, state)
    #{:ok, assign(socket, :score, %{left: a, right: b})}
    {:ok, socket}
  end
end
