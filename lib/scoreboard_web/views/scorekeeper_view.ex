defmodule ScoreboardWeb.ScorekeeperView do
  use ScoreboardWeb, :view

  alias Scoreboard.GameState.State

  defdelegate can_switch_sides?(state), to: State
  defdelegate invalid_score?(state), to: State
  defdelegate set_over?(state), to: State
  defdelegate game_over?(state), to: State

  defp get_team(state, side) when side in [:left, :right] do
    {left, right} = State.scorekeeper_display_order(state)

    case side do
      :left -> left
      :right -> right
    end
  end

  def team_name(state, side) when side in [:left, :right] do
    State.team_name(state, get_team(state, side))
  end

  def current_score(state, side) when side in [:left, :right] do
    team = get_team(state, side)
    {a, b} = State.current_set(state)

    case team do
      :team_a -> a
      :team_b -> b
    end
  end

  def sets_count(state, side) when side in [:left, :right] do
    {a, b} = State.sets_count(state)

    case get_team(state, side) do
      :team_a -> a
      :team_b -> b
    end
  end
end
