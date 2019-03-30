defmodule ScoreboardWeb.ScoreController do
  use ScoreboardWeb, :controller

  def index(conn, _params) do
    {:ok, score} = Scoreboard.GameState.get_score()

    conn
    |> put_layout("scoreboard.html")
    |> assign(:score, "#{score.left} - #{score.right}")
    |> render("index.html")
  end
end
