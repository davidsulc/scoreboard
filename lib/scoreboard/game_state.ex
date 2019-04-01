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

  # def handle_call({:inc_score, side}, _from, state) do
  #   state = Map.update!(state, side, &(&1 + 1))
  #   {:reply, state, state}
  # end

  # def handle_call({:dec_score, side}, _from, state) do
  #   state = Map.update!(state, side, &(&1 - 1))
  #   {:reply, state, state}
  # end
end
