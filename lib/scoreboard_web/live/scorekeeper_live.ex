defmodule ScoreboardWeb.ScorekeeperLive do
  use Phoenix.LiveView

  alias ScoreboardWeb.ScorekeeperView

  def render(assigns) do
    ScorekeeperView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, assign(socket, :val, 0)}
  end

  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end
end
