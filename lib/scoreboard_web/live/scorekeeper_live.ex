defmodule ScoreboardWeb.ScorekeeperLive do
  use Phoenix.LiveView

  alias ScoreboardWeb.ScorekeeperView

  def render(assigns) do
    ScorekeeperView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, score} = Scoreboard.GameState.get_score()
    {:ok, assign(socket, :score, score)}
  end

  def handle_event("inc-right", _, socket) do
    score = Scoreboard.GameState.inc_score(:right)
    ScoreboardWeb.Endpoint.broadcast("scoreboard:lobby", "update", %{score: score})
    {:noreply, assign(socket, :score, score)}
  end

  def handle_event("dec-right", _, socket) do
    score = Scoreboard.GameState.dec_score(:right)
    ScoreboardWeb.Endpoint.broadcast("scoreboard:lobby", "update", %{score: score})
    {:noreply, assign(socket, :score, score)}
  end

  def handle_event("inc-left", _, socket) do
    score = Scoreboard.GameState.inc_score(:left)
    ScoreboardWeb.Endpoint.broadcast("scoreboard:lobby", "update", %{score: score})
    {:noreply, assign(socket, :score, score)}
  end

  def handle_event("dec-left", _, socket) do
    score = Scoreboard.GameState.dec_score(:left)
    ScoreboardWeb.Endpoint.broadcast("scoreboard:lobby", "update", %{score: score})
    {:noreply, assign(socket, :score, score)}
  end
end
