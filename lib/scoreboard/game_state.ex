defmodule Scoreboard.GameState do
  use GenServer

  @name __MODULE__

  def start_link(params) do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def get_score() do
    GenServer.call(@name, :get_score)
  end

  def inc_score() do
    GenServer.call(@name, :inc_score)
  end

  def dec_score() do
    GenServer.call(@name, :dec_score)
  end

  def init(_params) do
    {:ok, 4}
  end

  def handle_call(:get_score, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call(:inc_score, _from, state) do
    state = state + 2
    {:reply, state, state}
  end

  def handle_call(:dec_score, _from, state) do
    state = state - 3
    {:reply, state, state}
  end
end
