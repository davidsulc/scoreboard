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

  def inc_a() do
    GenServer.call(@name, :inc_a)
  end

  def inc_b() do
    GenServer.call(@name, :inc_b)
  end

  def inc_score(side) do
    GenServer.call(@name, {:inc_score, side})
  end

  def dec_score(side) do
    GenServer.call(@name, {:dec_score, side})
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

  def handle_call(:inc_a, _from, %{current_set: {a, b}} = state) do
    %{state | current_set: {a + 1, b}} |> handle_state_update()
  end

  def handle_call(:inc_b, _from, %{current_set: {a, b}} = state) do
    %{state | current_set: {a, b + 1}} |> handle_state_update()
  end

  defp handle_state_update(state) do
    Phoenix.PubSub.broadcast(Scoreboard.PubSub, "score", state)
    {:reply, {:ok, state}, state}
  end
end
