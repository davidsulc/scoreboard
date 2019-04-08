defmodule ScoreboardWeb.ViewHelpers.Score do
  alias Scoreboard.GameState.State

  defdelegate can_switch_sides?(state), to: State
  defdelegate set_over?(state), to: State
  defdelegate game_over?(state), to: State

  def team_name(state, team) do
    State.team_name(state, get_team(state, team))
  end

  defp get_team(state, side) when side in [:left, :right] do
    {left, right} = State.display_order(state)

    case side do
      :left -> left
      _ -> right
    end
  end

  defp get_team(_state, team), do: team

  def current_score(state, team_or_side) do
    team = get_team(state, team_or_side)
    {a, b} = State.current_set(state)

    case team do
      :team_a -> a
      :team_b -> b
    end
  end

  def pretty_sets(state) do
    State.traverse_finished_sets(state, fn set ->
      set_result =
        case set do
          {left, right} = set when left > right -> {set, ""}
          set -> {"", set}
        end

      format_set_result(set_result)
    end)
  end

  defp format_set_result({x, y}),
      do: {set_to_string(x), set_to_string(y)}

  defp set_to_string({a, b}), do: "#{a} - #{b}"
  defp set_to_string(""), do: ""

  def sets_count(state, team_or_side) do
    {a, b} = State.sets_count(state)

    case get_team(state, team_or_side) do
      :team_a -> a
      :team_b -> b
    end
  end
end
