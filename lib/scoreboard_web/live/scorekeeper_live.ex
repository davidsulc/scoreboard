defmodule ScoreboardWeb.ScorekeeperLive do
  use Phoenix.LiveView

  alias Scoreboard.GameState
  alias Scoreboard.GameState.State
  alias ScoreboardWeb.ScorekeeperView

  require Logger

  def render(assigns) do
    Phoenix.View.render(ScorekeeperView, "index.html", assigns)
  end

  def mount(_session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(Scoreboard.PubSub, "score")

    {:ok, state} = Scoreboard.GameState.state()
    {left, right} = State.display_order(state)

    socket =
      socket
      |> assign(:state, state)
      |> assign(:left_team, left)
      |> assign(:right_team, right)

    {:ok, socket}
  end

  def handle_info(%Scoreboard.GameState.State{} = state, socket) do
    {:noreply, assign(socket, :state, state)}
  end

  def handle_event("switch", _, socket) do
    GameState.switch_sides()

    {:noreply, socket}
  end

  def handle_event("inc-left", _, socket) do
    {left, _} = State.display_order(socket.assigns.state)
    GameState.inc(left)

    {:noreply, socket}
  end

  def handle_event("inc-right", _, socket) do
    {_, right} = State.display_order(socket.assigns.state)
    GameState.inc(right)

    {:noreply, socket}
  end

  def handle_event("dec-left", _, socket) do
    {left, _} = State.display_order(socket.assigns.state)
    GameState.dec(left)

    {:noreply, socket}
  end

  def handle_event("dec-right", _, socket) do
    {_, right} = State.display_order(socket.assigns.state)
    GameState.dec(right)

    {:noreply, socket}
  end

  def handle_event("end-set", _, socket) do
    GameState.end_set()

    {:noreply, socket}
  end
end
