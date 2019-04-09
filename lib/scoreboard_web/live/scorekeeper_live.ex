defmodule ScoreboardWeb.ScorekeeperLive do
  use Phoenix.LiveView

  alias Scoreboard.GameState
  alias Scoreboard.GameState.State
  alias ScoreboardWeb.ScorekeeperView

  @left_team_inc_key "a"
  @left_team_dec_key "A"
  @right_team_inc_key "l"
  @right_team_dec_key "L"
  @switch_sides_key "u"

  def render(assigns) do
    Phoenix.View.render(ScorekeeperView, "index.html", assigns)
  end

  def mount(_session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(Scoreboard.PubSub, "score")

    {:ok, state} = Scoreboard.GameState.state()
    {left, right} = State.scorekeeper_display_order(state)

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

  def handle_event("keyup", @left_team_inc_key, socket) do
    change_score(socket, :left, :inc)
    {:noreply, socket}
  end

  def handle_event("keyup", @left_team_dec_key, socket) do
    change_score(socket, :left, :dec)
    {:noreply, socket}
  end

  def handle_event("keyup", @right_team_inc_key, socket) do
    change_score(socket, :right, :inc)
    {:noreply, socket}
  end

  def handle_event("keyup", @right_team_dec_key, socket) do
    change_score(socket, :right, :dec)
    {:noreply, socket}
  end

  def handle_event("keyup", @switch_sides_key, socket) do
    GameState.switch_sides()
    {:noreply, socket}
  end

  def handle_event("keyup", _key, socket) do
    {:noreply, socket}
  end

  def handle_event("switch", _, socket) do
    GameState.switch_sides()
    {:noreply, socket}
  end

  def handle_event(event, _, socket) when event in ~w(dec-left inc-left dec-right inc-right) do
    [operation, side] = event |> String.split("-") |> Enum.map(&String.to_atom/1)
    change_score(socket, side, operation)
    {:noreply, socket}
  end

  def handle_event("end-set", _, socket) do
    GameState.end_set()
    {:noreply, socket}
  end

  defp change_score(socket, :left, :inc) do
    {left, _} = State.scorekeeper_display_order(socket.assigns.state)
    GameState.inc(left)
  end

  defp change_score(socket, :left, :dec) do
    {left, _} = State.scorekeeper_display_order(socket.assigns.state)
    GameState.dec(left)
  end

  defp change_score(socket, :right, :inc) do
    {_, right} = State.scorekeeper_display_order(socket.assigns.state)
    GameState.inc(right)
  end

  defp change_score(socket, :right, :dec) do
    {_, right} = State.scorekeeper_display_order(socket.assigns.state)
    GameState.dec(right)
  end
end
