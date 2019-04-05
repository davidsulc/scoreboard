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

  def init(params) do
    {:ok, %State{}}
  end

  def handle_call(:state, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:merge, state_update}, _from, state) do
    state
    # TODO validate state_update w/ changeset
    |> Map.merge(state_update)
    # TODO
    # |> State.update_win_conditions()
    |> handle_state_update()
  end

  defp handle_state_update(state) do
    Phoenix.PubSub.broadcast(Scoreboard.PubSub, "score", state)
    {:reply, {:ok, state}, state}
  end
end
