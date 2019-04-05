defmodule ScoreboardWeb.ScorekeeperLive do
  use Phoenix.LiveView

  alias ScoreboardWeb.ScorekeeperView

  def render(assigns) do
    ScorekeeperView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, state} = Scoreboard.GameState.state()
    {a, b} = Scoreboard.GameState.State.current_set(state)

    socket =
      socket
      |> assign(:score, %{left: a, right: b})
      |> assign(:state, state)
    #{:ok, assign(socket, :score, %{left: a, right: b})}
    {:ok, socket}
  end
end
