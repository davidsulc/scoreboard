defmodule ScoreboardWeb.ScorekeeperLive do
  use Phoenix.LiveView

  alias ScoreboardWeb.ScorekeeperView

  def render(assigns) do
    ScorekeeperView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, score} = Scoreboard.GameState.get_score()
    {:ok, assign(socket, :val, score)}
  end

  def handle_event("inc", _, socket) do
    score = Scoreboard.GameState.inc_score()
    ScoreboardWeb.Endpoint.broadcast("scoreboard:lobby", "update", %{score: score})
    {:noreply, assign(socket, :val, score)}
  end

  def handle_event("dec", _, socket) do
    score = Scoreboard.GameState.dec_score()
    ScoreboardWeb.Endpoint.broadcast("scoreboard:lobby", "update", %{score: score})
    {:noreply, assign(socket, :val, score)}
  end
end
