defmodule ScoreboardWeb.ScoreView do
  use ScoreboardWeb, :view

  def team_name(state, team), do: Map.get(state, team, "")

  def current_score(%{current_set: {a, _b}}, :team_a), do: a
  def current_score(%{current_set: {_a, b}}, :team_b), do: b

  def pretty_sets(%{scorekeeper_display_order: display_order, sets: sets}, display_order) do
    pretty_sets(sets)
  end

  def pretty_sets(%{sets: sets}, _display_order) do
    sets
    |> Enum.map(&reverse_set_scores/1)
    |> pretty_sets()
  end

  defp reverse_set_scores({a, b}), do: {b, a}

  defp pretty_sets(sets) do
    Enum.map(sets, fn set ->
      case set do
        {left, right} when left > right -> {set_to_string(set), ""}
        set -> {"", set_to_string(set)}
      end
    end)
  end

  defp set_to_string({a, b}), do: "#{a} - #{b}"

  def set_count(%{scorekeeper_display_order: order, sets: sets}, team) do
    {a, b} = set_count(sets)
    case order do
      {^team, _} -> a
      _ -> b
    end
  end

  defp set_count(sets) when is_list(sets) do
    Enum.reduce(sets, {0, 0}, fn set, {acc_a, acc_b} ->
      case set do
        {a, b} when a > b -> {acc_a + 1, acc_b}
        _ -> {acc_a, acc_b + 1}
      end
    end)
  end
end
