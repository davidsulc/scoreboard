defmodule ScoreboardWeb.ScoreView do
  use ScoreboardWeb, :view

  alias Scoreboard.GameState.State

  defdelegate can_switch_sides?(state), to: State
  defdelegate invalid_score?(state), to: State
  defdelegate set_over?(state), to: State
  defdelegate game_over?(state), to: State

  def order_flipped(state) do
    State.scoreboard_display_order(state) == {:team_b, :team_a}
  end

  def team_name(state, team) when team in [:team_a, :team_b] do
    State.team_name(state, team)
  end

  def current_score(state, team) when team in [:team_a, :team_b] do
    {a, b} = State.current_set(state)

    case team do
      :team_a -> a
      :team_b -> b
    end
  end

  def sets_count(state, team) when team in [:team_a, :team_b] do
    {a, b} = State.sets_count(state)

    case team do
      :team_a -> a
      :team_b -> b
    end
  end

  def pretty_sets(state) do
    order_score_results_for_display =
      case State.scoreboard_display_order(state) do
        {:team_a, :team_b} -> & &1
        {:team_b, :team_a} -> fn {a, b} -> {b, a} end
      end

    state
    |> State.traverse_finished_sets(order_score_results_for_display)
    |> Enum.map(&format_set/1)
  end

  defp format_set(set) do
    set
    |> set_winner_tuple()
    |> format_set_result()
  end

  defp set_winner_tuple({left, right} = set) when left > right, do: {set, ""}
  defp set_winner_tuple(set), do: {"", set}

  defp format_set_result({x, y}),
    do: {set_to_string(x), set_to_string(y)}

  defp set_to_string({a, b}), do: "#{a} - #{b}"
  defp set_to_string(""), do: ""
end
