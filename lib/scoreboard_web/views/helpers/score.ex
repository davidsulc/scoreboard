defmodule ScoreboardWeb.ViewHelpers.Score do
  alias Scoreboard.GameState.State

  defdelegate team_name(state, team), to: State
  defdelegate game_over?(state), to: State

  def current_score(state, team) do
    {a, b} = State.current_set(state)

    case team do
      :team_a -> a
      :team_b -> b
    end
  end

  def pretty_sets(state, display_order) do
    State.traverse_finished_sets(state, fn set ->
      set
      |> maybe_reverse_set_scores(State.display_order(state), display_order)
      |> case do
        {left, right} = set when left > right -> {set, ""}
        set -> {"", set}
      end
      |> format_set_result()
    end)
  end

  defp format_set_result({x, y}),
      do: {set_to_string(x), set_to_string(y)}

  defp maybe_reverse_set_scores({a, b}, {left, right}, {left, right}), do: {a, b}
  defp maybe_reverse_set_scores({a, b}, _, _), do: {b, a}

  defp set_to_string({a, b}), do: "#{a} - #{b}"
  defp set_to_string(""), do: ""

  def sets_count(state, team) do
    {a, b} = State.sets_count(state)

    case State.display_order(state) do
      {^team, _} -> a
      _ -> b
    end
  end
end
