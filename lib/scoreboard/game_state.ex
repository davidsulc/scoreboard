defmodule Scoreboard.GameState do
  use GenServer

  @name __MODULE__

  defmodule State do
    defstruct [
      scorekeeper_display_order: {:team_a, :team_b},
      team_a: "TV Murten",
      team_b: "VBC Schmitten",
      current_set: {8, 11},
      sets: [
        {19, 25},
        {27, 25},
        {22, 25},
        {25, 23}
      ]
    ]
  end

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
    |> handle_state_update()
  end

  defp handle_state_update(state) do
    Phoenix.PubSub.broadcast(Scoreboard.PubSub, "score", state)
    {:reply, {:ok, state}, state}
  end
end
