defmodule ScoreboardWeb.GameSetupView do
  use ScoreboardWeb, :view

  alias Scoreboard.GameState.State

  def input_for_set(f, state, opts) do
    set = Keyword.fetch!(opts, :set)
    team = Keyword.fetch!(opts, :team)

    text_input(f,
               :"set_#{set}_#{team}",
               name: "game[sets][#{set}][#{team}]",
               value: get_set_score(state, set, team))
  end

  defp get_set_score(state, set, team) do
    case State.get_set(state, set) do
      nil ->
        ""

      {a, b} ->
        case team do
          :team_a -> a
          :team_b -> b
          _ -> ""
        end
    end
  end
end
