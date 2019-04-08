defmodule Scoreboard.GameState.State do
  defstruct [
    scorekeeper_display_order: {:team_a, :team_b},
    can_be_switched: true,
    game_over: false,
    set_over: false,
    team_a: "",
    team_b: "",
    sets: [{0, 0}]
  ]

  def end_set(%__MODULE__{sets: sets} = state) do
    state =
      state
      |> check_game_over()
      |> case do
        %{game_over: true} = state -> state
        %{game_over: false} = state -> %{state | sets: [{0, 0} | sets]}
      end
      |> Map.replace!(:set_over, false)

    if tie_break?(state) do
      state
    else
      switch_sides(state)
    end
  end

  def switch_sides(%__MODULE__{scorekeeper_display_order: {old_left, old_right}} = state) do
    %{state | scorekeeper_display_order: {old_right, old_left}}
  end

  def merge(%__MODULE__{} = state, %{} = state_update) do
    state
    |> Map.merge(state_update)
    |> ensure_starting_set()
  end

  def change_score(%__MODULE__{sets: [current | finished]} = state, change) when is_function(change, 1) do
    state
    |> Map.replace!(:sets, [change.(current) | finished])
    |> check_score_conditions()
  end

  defp ensure_starting_set(%__MODULE__{sets: []} = state) do
    %{state | sets: [{0, 0}]}
  end

  defp ensure_starting_set(%__MODULE__{} = state), do: state

  defp check_game_over(%__MODULE__{sets: sets} = state) do
    game_over =
      sets
      |> count_won_sets()
      |> Tuple.to_list()
      |> Enum.any?(&(&1 > 2))

    %{state | game_over: game_over}
  end

  defp count_won_sets(sets) when is_list(sets) do
    Enum.reduce(sets, {0, 0}, fn set, {acc_a, acc_b} ->
      case set do
        {a, b} when a > b -> {acc_a + 1, acc_b}
        _ -> {acc_a, acc_b + 1}
      end
    end)
  end

  def team_name(%__MODULE__{} = state, team), do: Map.get(state, team, "")

  def display_order(%__MODULE__{scorekeeper_display_order: order}), do: order

  def current_set(%__MODULE__{sets: [current | _]}), do: current

  def can_switch_sides?(%__MODULE__{can_be_switched: switch}), do: switch

  def tie_break?(%__MODULE__{sets: sets}), do: length(sets) > 4

  def set_over?(%__MODULE__{set_over: set_over}), do: set_over

  def game_over?(%__MODULE__{game_over: game_over}), do: game_over

  def sets_count(%__MODULE__{} = state) do
    state
    |> finished_sets()
    |> count_won_sets()
  end

  defp finished_sets(%__MODULE__{game_over: true, sets: sets}), do: sets

  defp finished_sets(%__MODULE__{game_over: false, sets: [_current_set | finished_sets]}),
      do: finished_sets

  def traverse_finished_sets(%__MODULE__{} = state, fun) do
    state
    |> finished_sets()
    |> Enum.reverse()
    |> Enum.map(fun)
  end

  def check_score_conditions(%__MODULE__{} = state) do
    state
    |> check_set_over()
    |> check_can_switch_sides()
  end

  defp check_can_switch_sides(%__MODULE__{sets: [{0, 0}]} = state) do
    %{state | can_be_switched: true}
  end

  defp check_can_switch_sides(%__MODULE__{sets: [{a, b} | _] = sets} = state)
      when length(sets) > 4 and ((a == 8 and b < 8) or (a < 8 and b == 8)) do
    %{state | can_be_switched: true}
  end

  defp check_can_switch_sides(%__MODULE__{} = state) do
    %{state | can_be_switched: false}
  end

  defp check_set_over(%__MODULE__{} = state) do
    %{state | set_over: current_set_over?(state)}
  end

  defp current_set_over?(%__MODULE__{} = state) do
    set_end_min = if tie_break?(state), do: 15, else: 25

    state
    |> current_set()
    |> set_over?(set_end_min)
  end

  defp set_over?({a, b}, min) do
    (a >= min or b >= min) and abs(a - b) > 1
  end

  def get_set(%__MODULE__{sets: sets}, set_index) do
    Enum.at(sets, -1 - set_index)
  end
end
