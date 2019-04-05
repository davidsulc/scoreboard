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
      |> State.check_set_over()
      |> case do
        %{set_over: true} = state -> State.end_set(state)
        state -> state
      end
      |> broadcast_state()

    {:reply, {:ok, state}, state}
  end

  defp broadcast_state(state) do
    Phoenix.PubSub.broadcast(Scoreboard.PubSub, "score", state)
    state
  end
end
