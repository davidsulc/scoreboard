defmodule Scoreboard.GameState.State do
  defstruct [
    scorekeeper_display_order: {:team_a, :team_b},
    game_over: false,
    set_over: false,
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

  def team_name(%__MODULE__{} = state, team), do: Map.get(state, team, "")

  def display_order(%__MODULE__{scorekeeper_display_order: order}), do: order

  def current_set(%__MODULE__{sets: [current | _]}), do: current

  def tie_break?(%__MODULE__{sets: sets}), do: Enum.count(sets) > 4

  def game_over?(%__MODULE__{sets: sets} = state) do
    state
    |> sets_count()
    |> Tuple.to_list()
    |> Enum.any?(&(&1 > 2))
  end

  def sets_count(%__MODULE__{} = state) do
    state
    |> finished_sets()
    |> Enum.reduce({0, 0}, fn set, {acc_a, acc_b} ->
      case set do
        {a, b} when a > b -> {acc_a + 1, acc_b}
        _ -> {acc_a, acc_b + 1}
      end
    end)
  end

  defp finished_sets(%__MODULE__{game_over: true, sets: sets}), do: sets

  defp finished_sets(%__MODULE__{game_over: false, sets: [_current_set | finished_sets]}),
      do: finished_sets

  def traverse_finished_sets(%__MODULE__{} = state, fun) do
    state
    |> finished_sets()
    |> Enum.map(fun)
  end
end
