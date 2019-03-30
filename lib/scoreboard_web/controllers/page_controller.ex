defmodule ScoreboardWeb.PageController do
  use ScoreboardWeb, :controller

  def index(conn, _params) do
    {:ok, score} = Scoreboard.GameState.get_score()

    conn
    |> assign(:score, score)
    |> render("index.html")
  end
end
