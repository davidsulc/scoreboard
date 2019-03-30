defmodule ScoreboardWeb.PageController do
  use ScoreboardWeb, :controller

  def index(conn, _params) do
    {:ok, score} = Scoreboard.GameState.get_score()

    conn
    |> assign(:score, "#{score.left} - #{score.right}")
    |> render("index.html")
  end
end
