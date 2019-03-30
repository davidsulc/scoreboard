defmodule Scoreboard.GameState do
  use GenServer

  @name __MODULE__

  def start_link(params) do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def get_score() do
    GenServer.call(@name, :get_score)
  end

  def inc_score(side) do
    GenServer.call(@name, {:inc_score, side})
  end

  def dec_score(side) do
    GenServer.call(@name, {:dec_score, side})
  end

  def init(_params) do
    {:ok, %{left: 0, right: 0}}
  end

  def handle_call(:get_score, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:inc_score, side}, _from, state) do
    state = Map.update!(state, side, &(&1 + 1))
    {:reply, state, state}
  end

  def handle_call({:dec_score, side}, _from, state) do
    state = Map.update!(state, side, &(&1 - 1))
    {:reply, state, state}
  end
end
