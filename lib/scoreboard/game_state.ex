defmodule Scoreboard.GameState do
  use GenServer

  alias Scoreboard.GameState.State

  @name __MODULE__

  def start_link(params) do
    GenServer.start_link(__MODULE__, [params], name: @name)
  end

  def state() do
    GenServer.call(@name, :state)
  end

  def merge(state) when is_map(state) do
    GenServer.call(@name, {:merge, state})
  end

  def switch_sides() do
    GenServer.call(@name, :switch)
  end

  def inc(team) do
    GenServer.call(@name, {:inc, team})
  end

  def dec(team) do
    GenServer.call(@name, {:dec, team})
  end

  def end_set() do
    GenServer.call(@name, :end_set)
  end

  def init(_params) do
    {:ok, %State{}}
  end

  def handle_call(:state, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:merge, state_update}, _from, state) do
    state =
      state
      # TODO validate state_update w/ changeset
      |> State.merge(state_update)
      |> State.check_score_conditions()
      |> case do
        %{set_over: true} = state -> State.end_set(state)
        state -> state
      end
      |> broadcast_state()

    {:reply, {:ok, state}, state}
  end

  def handle_call(:switch, _from, state) do
    state =
      state
      |> State.switch_sides()
      |> broadcast_state()

    {:reply, {:ok, state}, state}
  end

  def handle_call({:inc, :team_a}, _from, state) do
    state = change_score(state, fn {a, b} -> {a + 1, b} end)
    {:reply, {:ok, state}, state}
  end

  def handle_call({:inc, :team_b}, _from, state) do
    state = change_score(state, fn {a, b} -> {a, b + 1} end)
    {:reply, {:ok, state}, state}
  end

  def handle_call({:dec, :team_a}, _from, %{sets: [{0, _} | _]} = state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:dec, :team_b}, _from, %{sets: [{_, 0} | _]} = state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:dec, :team_a}, _from, state) do
    state = change_score(state, fn {a, b} -> {a - 1, b} end)
    {:reply, {:ok, state}, state}
  end

  def handle_call({:dec, :team_b}, _from, state) do
    state = change_score(state, fn {a, b} -> {a, b - 1} end)
    {:reply, {:ok, state}, state}
  end

  def handle_call(:end_set, _from, state) do
    state =
      state
      |> State.end_set()
      |> broadcast_state()

    {:reply, {:ok, state}, state}
  end

  defp change_score(state, change) when is_function(change, 1) do
    state
    |> State.change_score(change)
    |> broadcast_state()
  end

  defp broadcast_state(state) do
    Phoenix.PubSub.broadcast(Scoreboard.PubSub, "score", state)
    state
  end
end
