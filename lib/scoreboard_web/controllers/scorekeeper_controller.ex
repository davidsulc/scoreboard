defmodule ScoreboardWeb.ScorekeeperController do
  use ScoreboardWeb, :controller

  def index(conn, _params) do
    {:ok, state} = Scoreboard.GameState.state()

    conn
    |> assign(:state, state)
    |> assign(:left_team, :team_a)
    |> assign(:right_team, :team_b)
    |> render("index.html")
  end
end
